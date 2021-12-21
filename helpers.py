def strToByteArray(str, str_len):
    res = []
    strByteArray = bytearray(str, 'utf-8')

    assert len(strByteArray) <= str_len, "!(len(byte_array) <= str_len)"

    for i in range(str_len - len(strByteArray)):
        res.append(0)

    for i in range(len(strByteArray)):
        res.append(strByteArray[i])

    assert len(res) == str_len, "!(len(res) == str_len)"

    return res

def strToNumArray(str):
    result = []
    strBytes = bytearray(str, 'utf-8')
    for i in range(len(strBytes)):
        result.append(int.from_bytes(strBytes[i:i+1], byteorder='big'))

    return result

def genSubstrByteArray(plaintext, substr, numPlaintextBytes, numSubstrBytes):
    
    # substr must be a substring of plaintext
    SUBSTR_INDEX = plaintext.find(substr)
    assert SUBSTR_INDEX > -1, "substr must be a substring of plaintext"

    # numPlaintextBytes must be greater than numSubstrBytes
    assert numPlaintextBytes > numSubstrBytes, "numPlaintextBytes must be greater than numSubstrBytes"

    #Convert plaintext to a byte array num_plaintext_bytes long
    plaintextByteArray = strToByteArray(plaintext, numPlaintextBytes)
    assert len(plaintextByteArray) <= numPlaintextBytes, "!(len(plaintext_byte_array) <= num_plaintext_bytes)"

    if len(plaintextByteArray) == numSubstrBytes:
        return plaintextByteArray, 0

    # substring to byte array
    result = strToNumArray(substr)

    # numSubstrBytes must be greater than num_plaintext_bytes
    assert numSubstrBytes >= len(result), "numSubstrBytes must be greater than or equal to len(substr_num_array)"

    if numSubstrBytes == len(result):
        return result, 0

    post = plaintext[SUBSTR_INDEX + len(substr):]
    post_bytes = strToNumArray(post)

    for i in range(len(post_bytes)):
        result.append(post_bytes[i])

    if (len(result) >= numSubstrBytes):
        return result[0:numSubstrBytes], 0

    pre = plaintext[0: SUBSTR_INDEX]
    pre_bytes = strToNumArray(pre)
    while (len(pre_bytes) < numSubstrBytes):
        pre_bytes.insert(0, 0)

    i = len(pre_bytes) - 1
    while (len(result) < numSubstrBytes):
        b = pre_bytes[i]
        result.insert(0, b)
        i -= 1

    pos = 0
    while (pos < numPlaintextBytes - numSubstrBytes):
        if plaintextByteArray[pos: pos+numSubstrBytes] == result:
            break
        pos += 1
    return result, pos    