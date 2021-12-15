def str_to_byte_array(str, str_len):
    res = []
    str_byte_array = bytearray(str, 'utf-8')

    assert len(str_byte_array) <= str_len, "!(len(byte_array) <= str_len)"

    for i in range(str_len - len(str_byte_array)):
        res.append(0)

    for i in range(len(str_byte_array)):
        res.append(str_byte_array[i])

    assert len(res) == str_len, "!(len(res) == str_len)"

    return res

def str_to_num_array(str):
    result = []
    str_bytes = bytearray(str, 'utf-8')
    for i in range(len(str_bytes)):
        result.append(int.from_bytes(str_bytes[i:i+1], byteorder='big'))

    return result

def gen_substring_byte_array(plaintext, substr, num_plaintext_bytes, num_substr_bytes):
    
    # substr must be a substring of plaintext
    SUBSTR_INDEX = plaintext.find(substr)
    assert SUBSTR_INDEX > -1, "substr must be a substring of plaintext"

    # num_plaintext_bytes must be greater than num_substr_bytes
    assert num_plaintext_bytes > num_substr_bytes, "num_plaintext_bytes must be greater than num_substr_bytes"

    #Convert plaintext to a byte array num_plaintext_bytes long
    plaintext_byte_array = str_to_byte_array(plaintext, num_plaintext_bytes)
    assert len(plaintext_byte_array) <= num_plaintext_bytes, "!(len(plaintext_byte_array) <= num_plaintext_bytes)"

    if len(plaintext_byte_array) == num_substr_bytes:
        return plaintext_byte_array, 0

    # substring to byte array
    result = str_to_num_array(substr)

    # num_substr_bytes must be greater than num_plaintext_bytes
    assert num_substr_bytes >= len(result), "num_substr_bytes must be greater than or equal to len(substr_num_array)"

    if result == len(result):
        return result, 0

    post = plaintext[SUBSTR_INDEX + len(substr):]
    post_bytes = str_to_num_array(post)

    for i in range(len(post_bytes)):
        result.append(post_bytes[i])

    if (len(post_bytes) >= num_substr_bytes):
        return result[0, num_substr_bytes], 0

    pre = plaintext[0: SUBSTR_INDEX]
    pre_bytes = str_to_num_array(pre)
    while (len(pre_bytes) < num_substr_bytes):
        pre_bytes.insert(0, 0)

    i = len(pre_bytes) - 1
    while (len(result) < num_substr_bytes):
        b = pre_bytes[i]
        result.insert(0, b)
        i -= 1

    pos = 0
    while (pos < num_plaintext_bytes - num_substr_bytes):
        if plaintext_byte_array[pos: pos+num_substr_bytes] == result:
            break
        pos += 1
    return result, pos    