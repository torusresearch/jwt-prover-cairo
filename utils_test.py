import os

import pytest
from starkware.starknet.testing.starknet import Starknet
from starkware.starkware_utils.error_handling import StarkException

CONTRACT_FILE = os.path.join("", "utils.test.cairo")
NUM_BYTES = 320

@pytest.mark.asyncio
async def test_array_sum():
    """Test array_sum method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_array_sum(arr=[1,2,3]).call()
    assert execution_info.result == (6,)

    execution_info = await contract.test_array_sum(arr=[10,20,30,40,50,60]).call()
    assert execution_info.result == (210,)

@pytest.mark.asyncio
async def test_compare_arrays():
    """Test compare_arrays method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_compare_arrays(a=[1,2,3], b=[1,2,3]).call()
    assert execution_info.result == (1,)

    with pytest.raises(StarkException):
        await contract.test_compare_arrays(a=[1,2,3], b=[2,2,3]).call()

@pytest.mark.asyncio
async def test_array_ends_with():
    """Test array_ends_with method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_array_ends_with(a=[1,2,3], b=[0,2,3], target_len=2).call()
    assert execution_info.result == (1,)

    execution_info = await contract.test_array_ends_with(a=[1,2,3,4,5,6,7,8,9], b=[0,0,0,4,5,6,7,8,9], target_len=6).call()
    assert execution_info.result == (1,)

    with pytest.raises(StarkException):
        await contract.test_array_ends_with(a=[1,2,3], b=[0,1,3], target_len=2).call()
    
    with pytest.raises(StarkException):
        await contract.test_array_ends_with(a=[1,2,3], b=[0,3], target_len=1).call()

@pytest.mark.asyncio
async def test_exponent():
    """Test test_exponent method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_exponent(x=2, n=2).call()
    assert execution_info.result == (4,)

    execution_info = await contract.test_exponent(x=2, n=4).call()
    assert execution_info.result == (16,)

    execution_info = await contract.test_exponent(x=4, n=2).call()
    assert execution_info.result == (16,)

@pytest.mark.asyncio
async def test_num_bytes_in_bits():
    """Test num_bytes_in_bits method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_num_bytes_in_bits(bytes_in_bits=2, num_bytes=4).call()
    assert execution_info.result == (2,)

@pytest.mark.asyncio
async def test_slicer():
    """Test slicer method."""
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
    )

    execution_info = await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=2, start_index=1).call()
    assert execution_info.result == ([0, 0, 0, 0, 0, 0, 1, 2],)

    with pytest.raises(StarkException):
        await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=2, start_index=8).call()
    
    with pytest.raises(StarkException):
        await contract.test_slicer(arr=[0, 1, 2, 3, 4, 5, 6, 7], len=8, start_index=1).call()