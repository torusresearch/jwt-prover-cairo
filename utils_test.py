import os

import pytest
from starkware.starknet.testing.starknet import Starknet
from starkware.starkware_utils.error_handling import StarkException

CONTRACT_FILE = os.path.join("", "utils.test.cairo")
NUM_BYTES = 320

@pytest.mark.asyncio
async def testArraySum():
    """Test array_sum method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_array_sum(arr=[1,2,3]).call()
    assert executionInfo.result == (6,)

    executionInfo = await contract.test_array_sum(arr=[10,20,30,40,50,60]).call()
    assert executionInfo.result == (210,)

@pytest.mark.asyncio
async def testCompareArrays():
    """Test compare_arrays method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_compare_arrays(a=[1,2,3], b=[1,2,3]).call()
    assert executionInfo.result == (1,)

    with pytest.raises(StarkException):
        await contract.test_compare_arrays(a=[1,2,3], b=[2,2,3]).call()

@pytest.mark.asyncio
async def testArrayEndsWith():
    """Test array_ends_with method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_array_ends_with(a=[1,2,3], b=[0,2,3], target_len=2).call()
    assert executionInfo.result == (1,)

    executionInfo = await contract.test_array_ends_with(a=[1,2,3,4,5,6,7,8,9], b=[0,0,0,4,5,6,7,8,9], target_len=6).call()
    assert executionInfo.result == (1,)

    with pytest.raises(StarkException):
        await contract.test_array_ends_with(a=[1,2,3], b=[0,1,3], target_len=2).call()
    
    with pytest.raises(StarkException):
        await contract.test_array_ends_with(a=[1,2,3], b=[0,3], target_len=1).call()

@pytest.mark.asyncio
async def testExponent():
    """Test test_exponent method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_exponent(x=2, n=2).call()
    assert executionInfo.result == (4,)

    executionInfo = await contract.test_exponent(x=2, n=4).call()
    assert executionInfo.result == (16,)

    executionInfo = await contract.test_exponent(x=4, n=2).call()
    assert executionInfo.result == (16,)

@pytest.mark.asyncio
async def testNumBytesInBits():
    """Test num_bytes_in_bits method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_num_bytes_in_bits(bytes_in_bits=2, num_bytes=4).call()
    assert executionInfo.result == (2,)

@pytest.mark.asyncio
async def testSlicer():
    """Test slicer method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=2, start_index=1).call()
    assert executionInfo.result == ([0, 0, 0, 0, 0, 0, 1, 2],)

    with pytest.raises(StarkException):
        await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=2, start_index=8).call()
    
    with pytest.raises(StarkException):
        await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=8, start_index=1).call()


@pytest.mark.asyncio
async def testSubstringMatcher():
    """Test substring_matcher method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    executionInfo = await contract.test_substring_matcher(a=[1, 2, 3, 4, 5], b=[2,3]).call()
    assert executionInfo.result == (1,)

    executionInfo = await contract.test_substring_matcher(a=[1, 2, 3, 4, 5], b=[1,3,4]).call()
    assert executionInfo.result == (0,)

    executionInfo = await contract.test_substring_matcher(a=[1, 2, 3, 4, 5, 6, 7, 8, 9], b=[2,3,4,5]).call()
    assert executionInfo.result == (1,)

    executionInfo = await contract.test_substring_matcher(a=[1, 2, 3, 4, 5, 6, 7, 8, 9], b=[1,3,4,5]).call()
    assert executionInfo.result == (1,)