sentence = "harif harif aval hafif li"
newSentence = sentence.split()
print(newSentence)
newSentenceDict = {}
for word in newSentence:
    if word in newSentenceDict:
        newSentenceDict[word] += 1
    else:
        newSentenceDict[word] = 1

print(newSentenceDict)