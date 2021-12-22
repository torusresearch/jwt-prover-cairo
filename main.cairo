%builtins output range_check

from starkware.cairo.common.serialize import serialize_word
from jwt_prover import jwt_hidden_email_address_prover

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    local pre_image_b64: felt*
    local pre_image_b64_len: felt
    local email_substr_b64: felt*
    local email_substr_b64_len: felt
    local email_substr_utf8: felt*
    local email_substr_utf8_len: felt
    local email_address: felt*
    local email_address_len: felt
    local email_substr_bit_index
    local email_substr_bit_len
    local email_key_start_pos
    local email_value_end_pos
    local num_spaces_before_colon
    local num_spaces_after_colon
    local num_email_address_bytes

    %{
        import base64
        import math
        import json
        import bitarray
        import re

        def extractEmailSubstr(payload):
            payloadJson = json.loads(payload)
            addr = payloadJson["email"]
            startIndex = payload.index(b'"email"')
            endIndex = payload.find(addr.encode()) + len(addr) + 1
            email = payload[startIndex:endIndex]
            return email

        def calNumPreImageB64PaddedBytes(data):
            b = bytearray(data, 'utf-8')
            b_len = 1 + len(b) * 8
            n_blocks = math.floor((b_len + 64) / 512) + 1
            return int(n_blocks * 512 / 8)

        def calNumEmailSubstrB64Bytes(payload):
            email = extractEmailSubstr(payload)
            return len(email)

        def strToPaddedBytes(s):
            s_bytes = s.encode('utf-8')
            s_bits = bitarray.bitarray()
            s_bits.frombytes(s_bytes)
            s_bits_len = len(s_bits)
            n_blocks = math.floor((s_bits_len + 64) / 512) + 1

            while(len(s_bits) < n_blocks * 512 - 64):
                s_bits.append(0)

            len_bit_arr = []
            length_in_bits = "{0:b}".format(s_bits_len)
            for i in range(0, len(length_in_bits)):
                len_bit_arr.append(int(length_in_bits[i]))

            while (len(len_bit_arr) < 64):
                len_bit_arr.insert(0,0)

            for i in range(0, 64):
                s_bits.append(len_bit_arr[i])

            p = []

            for i in range(0, int(len(s_bits) / 8)):
                b_str = ''.join([str(int(x)) for x in s_bits[i * 8: i * 8 + 8]])
                p.append(int(b_str, 2))

            return p

        # Slightly modified base64url algorithm. The . character is converted to
        # 000000 in binary.
        def jwtBytesToBits(jwtBytes):
            base64urlChars = {
                'A': 0, 'B': 1, 'C': 2, 'D': 3, 'E': 4,
                'F': 5, 'G': 6, 'H': 7, 'I': 8, 'J': 9,
                'K': 10, 'L': 11, 'M': 12, 'N': 13, 'O': 14,
                'P': 15, 'Q': 16, 'R': 17, 'S': 18, 'T': 19,
                'U': 20, 'V': 21, 'W': 22, 'X': 23, 'Y': 24,
                'Z': 25, 'a': 26, 'b': 27, 'c': 28, 'd': 29,
                'e': 30, 'f': 31, 'g': 32, 'h': 33, 'i': 34,
                'j': 35, 'k': 36, 'l': 37, 'm': 38, 'n': 39,
                'o': 40, 'p': 41, 'q': 42, 'r': 43, 's': 44,
                't': 45, 'u': 46, 'v': 47, 'w': 48, 'x': 49,
                'y': 50, 'z': 51, '0': 52, '1': 53, '2': 54,
                '3': 55, '4': 56, '5': 57, '6': 58, '7': 59,
                '8': 60, '9': 61, '-': 62, '_': 63,
            }

            values = []
            for j in jwtBytes:
                c = chr(j)

                if j == 0x2e or j == 0:
                    values.append(0)
                elif c in base64urlChars:
                    values.append(base64urlChars[c])
                else:
                    values.append(0)

            bits = []

            for v in values:
                b = "{0:b}".format(v)
                while (len(b) < 6):
                    b = "0" + b

                for i in range(0, 6):
                    bits.append(int(b[i]))

            return bits

        def strToByteArr(str, length):
            result = []
            str_b = bytearray(str, 'utf-8')
            assert length >= len(str_b)

            for i in range(0, length - len(str_b)):
                    result.append(0)

            for i in range(0, len(str_b)):
                result.append(int(str_b[i]))

            assert len(result) == length
            return result

        def strToNumArr(str):
            result = []
            str_bytes = bytearray(str, 'utf-8')
            for i in range(len(str_bytes)):
                result.append(int.from_bytes(str_bytes[i:i+1], byteorder='big'))

            return result

        def genSubstrByteArr(plaintext, substr, num_plaintext_bytes, num_substr_bytes):
            # substr must be a substring of plaintext
            SUBSTR_INDEX = plaintext.find(substr)
            assert SUBSTR_INDEX > -1, "substr must be a substring of plaintext"

            # num_plaintext_bytes must be greater than num_substr_bytes
            assert num_plaintext_bytes > num_substr_bytes, "num_plaintext_bytes must be greater than num_substr_bytes"

            #Convert plaintext to a byte array num_plaintext_bytes long
            plaintext_byte_array = strToByteArr(plaintext, num_plaintext_bytes)
            assert len(plaintext_byte_array) <= num_plaintext_bytes, "!(len(plaintext_byte_array) <= num_plaintext_bytes)"

            if len(plaintext_byte_array) == num_substr_bytes:
                return plaintext_byte_array

            # substring to byte array
            result = strToNumArr(substr)

            # num_substr_bytes must be greater than num_plaintext_bytes
            assert num_substr_bytes >= len(result), "num_substr_bytes must be greater than or equal to len(substr_num_array)"

            if num_substr_bytes == len(result):
                return result

            post = plaintext[SUBSTR_INDEX + len(substr):]
            post_bytes = strToNumArr(post)

            for i in range(len(post_bytes)):
                result.append(post_bytes[i])

            if (len(result) >= num_substr_bytes):
                return result[0:num_substr_bytes]

            pre = plaintext[0: SUBSTR_INDEX]
            pre_bytes = strToNumArr(pre)
            while (len(pre_bytes) < num_substr_bytes):
                pre_bytes.insert(0, 0)

            i = len(pre_bytes) - 1
            while (len(result) < num_substr_bytes):
                b = pre_bytes[i]
                result.insert(0, b)
                i -= 1

            # pos = 0
            # while (pos < num_plaintext_bytes - num_substr_bytes):
            #     if plaintext_byte_array[pos: pos+num_substr_bytes] == result:
            #         break
            #     pos += 1
            return result

        jwt = program_input['jwt']
        e = program_input['email_address'] + '"'

        s = jwt.split('.')
        header = base64.b64decode(s[0] + '==')
        payload = base64.b64decode(s[1] + '==')
        header_and_payload = s[0]+'.'+s[1]

        NUM_BYTES = calNumPreImageB64PaddedBytes(header_and_payload)
        NUM_EMAIL_SUBSTR_BYTES = calNumEmailSubstrB64Bytes(payload)

        preimagePaddedBytes = strToPaddedBytes(header_and_payload)
        NUM_PREIMAGE_B64_BYTES = len(preimagePaddedBytes)

        email = extractEmailSubstr(payload)
        NUM_EMAIL_SUBSTR_B64_BYTES = 64

        emailAsBits = bitarray.bitarray()
        emailAsBits.frombytes(email)
        emailAsBitStr = ''.join([str(int(x)) for x in emailAsBits])

        emailSubstrB64StartIndex = []
        emailSubstrB64 = 0

        for i in range(0, NUM_PREIMAGE_B64_BYTES):
            substr = preimagePaddedBytes[i:i+NUM_EMAIL_SUBSTR_B64_BYTES]
            substrBits = jwtBytesToBits(substr)
            if ''.join([str(int(x)) for x in substrBits]).find(emailAsBitStr) > -1:
                emailSubstrB64 = substr
                emailSubstrB64StartIndex = i
                break

        emailSubstrBits = jwtBytesToBits(emailSubstrB64)
        emailSubstrBitIndex = "".join([str(int(x)) for x in emailSubstrBits]).find(emailAsBitStr)

        emailSubstrUtf8Bytes = strToByteArr(email.decode(), int(NUM_EMAIL_SUBSTR_B64_BYTES * 6 / 8))

        emailSubstrUtf8 = genSubstrByteArr(payload.decode(), email.decode(), NUM_BYTES, 48)

        p = re.compile('"email"(\s*):(\s*)".+"$')
        m = p.match(email.decode())
        if m == None:
            raise Exception(
                f'Invalid email address')

        numSpacesBeforeColon = len(m.group(1))
        numSpacesAfterColon = len(m.group(2))

        emailKeyStartPos = len(emailSubstrUtf8Bytes) - len(email) - 1
        emailValueEndPos = emailKeyStartPos + len(email) - 1

        emailAddressBytes = strToByteArr(e, int(NUM_EMAIL_SUBSTR_B64_BYTES * 6 / 8))

        # set inputs
        ids.pre_image_b64 = pre_image_b64 = segments.add()
        ids.pre_image_b64_len = len(preimagePaddedBytes)
        for i in range(0, len(preimagePaddedBytes)):
            memory[pre_image_b64 + i] = preimagePaddedBytes[i]

        ids.email_substr_b64 = email_substr_b64 = segments.add()
        ids.email_substr_b64_len = len(emailSubstrB64)
        for i in range(0, len(emailSubstrB64)):
            memory[email_substr_b64 + i] = emailSubstrB64[i]
        
        ids.email_substr_utf8 = email_substr_utf8 = segments.add()
        ids.email_substr_utf8_len = len(emailSubstrUtf8)
        for i in range(0, len(emailSubstrUtf8)):
            memory[email_substr_utf8 + i] = emailSubstrUtf8[i]
        
        ids.email_address = email_address = segments.add()
        ids.email_address_len = len(emailAddressBytes)
        for i in range(0, len(emailAddressBytes)):
            memory[email_address + i] = emailAddressBytes[i]

        ids.email_substr_bit_index = emailSubstrBitIndex
        ids.email_substr_bit_len = len(emailAsBitStr)
        ids.email_key_start_pos = emailKeyStartPos
        ids.email_value_end_pos = emailValueEndPos
        ids.num_spaces_before_colon = numSpacesBeforeColon
        ids.num_spaces_after_colon = numSpacesAfterColon
        ids.num_email_address_bytes = len(e)

    %}

    jwt_hidden_email_address_prover(pre_image_b64_len=pre_image_b64_len, pre_image_b64=pre_image_b64, email_substr_b64_len=email_substr_b64_len, email_substr_b64=email_substr_b64, email_substr_utf8_len=email_substr_utf8_len, email_substr_utf8=email_substr_utf8, email_address_len=email_address_len, email_address=email_address, email_substr_bit_index=email_substr_bit_index, email_substr_bit_len=email_substr_bit_len, email_key_start_pos=email_key_start_pos, email_value_end_pos=email_value_end_pos, num_spaces_before_colon=num_spaces_before_colon, num_spaces_after_colon=num_spaces_after_colon, num_email_address_bytes=num_email_address_bytes)
    
    serialize_word(0)

    return ()
end