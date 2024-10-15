#!/usr/bin/env python3

import boto3
import json

def fetch_instances():
    ec2 = boto3.client('ec2', region_name='us-east-1')  # set to your region
    response = ec2.describe_instances(Filters=[
        {
            'Name': 'tag:Name',
            'Values': ['ansible-worker-*']
        }
    ])
    
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            if instance.get('State', {}).get('Name') == 'running':
                private_ip = instance.get('PrivateIpAddress')
                if private_ip:
                    instances.append({
                        'private_ip': private_ip,
                        'tags': instance['Tags'],
                        'instance_id': instance['InstanceId']
                    })
    return instances

def generate_inventory(instances):
    inventory = {
        '_meta': {
            'hostvars': {}
        },
        'ansible_workers': {
            'hosts': []
        }
    }
    
    for instance in instances:
        private_ip = instance['private_ip']
        hostname = f"worker-{instance['instance_id']}"
        
        inventory['ansible_workers']['hosts'].append(private_ip)
        
        inventory['_meta']['hostvars'][private_ip] = {
            'ansible_host': private_ip
        }
    
    return inventory

def main():
    instances = fetch_instances()
    inventory = generate_inventory(instances)
    
    print(json.dumps(inventory, indent=4))

if __name__ == "__main__":
    main()
