defmodule Ethers.BlockUtilsTest do
  use ExUnit.Case
  alias Ethers.BlockUtils
  doctest BlockUtils

  describe "current_block_number" do
    test "returns the current block number" do
      assert {:ok, n} = BlockUtils.current_block_number()
      assert n > 0
    end

    test "can override the rpc options" do
      assert {:ok, 1001} ==
               BlockUtils.current_block_number(
                 rpc_client: Ethers.TestRPCModule,
                 rpc_opts: [block: "0x3E9"]
               )
    end
  end

  describe "get_block_timestamp" do
    test "returns the block timestamp" do
      assert {:ok, n} = BlockUtils.current_block_number()
      assert {:ok, t} = BlockUtils.get_block_timestamp(n)
      assert abs(System.system_time(:second) - t) < 100
    end

    test "can override the rpc opts" do
      assert {:ok, 500} =
               BlockUtils.get_block_timestamp(100,
                 rpc_client: Ethers.TestRPCModule,
                 rpc_opts: [timestamp: 400]
               )
    end
  end

  describe "date_to_block_number" do
    test "calculates the right block number for a given date" do
      assert {:ok, n} = BlockUtils.current_block_number()
      assert {:ok, ^n} = BlockUtils.date_to_block_number(DateTime.utc_now())
      assert {:ok, ^n} = BlockUtils.date_to_block_number(DateTime.utc_now(), n)
      assert {:ok, ^n} = BlockUtils.date_to_block_number(DateTime.utc_now() |> DateTime.to_unix())
    end

    test "can override the rpc opts" do
      assert {:ok, 1001} =
               BlockUtils.date_to_block_number(
                 1000,
                 nil,
                 rpc_client: Ethers.TestRPCModule,
                 rpc_opts: [timestamp: 111, block: "0x3E9"]
               )

      assert {:ok, 1_693_699_060} =
               BlockUtils.date_to_block_number(
                 ~D[2023-09-03],
                 nil,
                 rpc_client: Ethers.TestRPCModule,
                 rpc_opts: [timestamp: 123, block: "0x1"]
               )
    end
  end
end