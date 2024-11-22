// Decompiled by library.dedaub.com
// 2024.11.19 09:03 UTC
// Compiled using the solidity compiler version 0.7.6





function oneEyedMan(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3, uint256 varg4) public payable {  find similar
    if (varg0 >> 96) {
        if (block.coinbase != address(varg0 >> 96)) {
            require(block.coinbase == address(varg2 >> 96), Error(16963));
            if ((address(varg2 >> 96)).balance == varg3 >> 128) {
                v0 = block.coinbase.call().value(msg.value).gas(2300 * !msg.value);
                require(bool(v0), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
            }
        } else if ((address(varg0 >> 96)).balance == varg1 >> 128) {
            v1 = block.coinbase.call().value(msg.value).gas(2300 * !msg.value);
            require(bool(v1), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        }
    }
    exit;
    if (msg.data.length != (varg4 >> 240) + 78) {
        v2 = this.balance;
        v3 = v4 = 76;
        while (v3 < msg.data.length) {
            CALLDATACOPY(132, v3 + 2, msg.data[v3] >> 240);
            v3 = (msg.data[v3] >> 240) + (v3 + 2);
            v5 = this.call(0x56eff5b7).gas(msg.gas);
        }
        0x1892(this.balance - v2, msg.gas);
    } else {
        v6 = v7 = 78;
        require(msg.gas >= 0x124f8 * (msg.data.length - v7) / 28, Error(0x6e6f20676173));
        v8, v9 = 0x1a30(v7);
        require(0 != v9, Error(0x6e6f206f7070));
        require(msg.gas >= 0x124f8 * (msg.data.length - v7) / 28, Error(0x6e6f20676173));
        v10 = v11 = 106;
        if (!v8) {
            v6 = msg.data.length - 28;
            v10 = msg.data.length - 56;
        }
        v12 = v13 = msg.data[v6] >> 248;
        v14 = v15 = this;
        if (msg.data[v10] >> 248 < 2) {
            v14 = v16 = msg.data[v10 + 2] >> 96;
        }
        require(msg.data.length - v7 + 17 <= uint64.max);
        v17 = new bytes[](msg.data.length - v7 + 17);
        if (msg.data.length - v7 + 17) {
            CALLDATACOPY(v17.data, msg.data.length, msg.data.length - v7 + 17);
        }
        CALLDATACOPY(v17.data, v7, msg.data.length - v7);
        v17[msg.data.length - v7] = (v9 << 128) + (v8 << 120);
        if (!v8) {
            if (v13 % 2) {
                v12 = v18 = v13 - 1;
            } else {
                v12 = v19 = v13 + 1;
            }
        }
        if (v12) {
            if (1 != v12) {
                if (2 != v12) {
                    v20 = new bytes[](v17.length);
                    v21 = v22 = 0;
                    while (v21 < v17.length) {
                        v20[v21] = v17[v21];
                        v21 += 32;
                    }
                    v23 = v24 = v17.length + v20.data;
                    if (0x1f & v17.length) {
                        MEM[v24 - (0x1f & v17.length)] = ~((uint8.max + 1) ** (32 - (0x1f & v17.length)) - 1) & MEM[v24 - (0x1f & v17.length)];
                    }
                    require(bool((address(msg.data[v6 + 2] >> 96)).code.size));
                    v25 = address(msg.data[v6 + 2] >> 96).swap(address(v14), True, v9, address(0x1000276a4), v20).gas(msg.gas);
                    require(bool(v25), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                    require(RETURNDATASIZE() >= 64);
                } else {
                    v26 = new bytes[](v17.length);
                    v27 = v28 = 0;
                    while (v27 < v17.length) {
                        v26[v27] = v17[v27];
                        v27 += 32;
                    }
                    v29 = v30 = v17.length + v26.data;
                    if (0x1f & v17.length) {
                        MEM[v30 - (0x1f & v17.length)] = ~((uint8.max + 1) ** (32 - (0x1f & v17.length)) - 1) & MEM[v30 - (0x1f & v17.length)];
                    }
                    require(bool((address(msg.data[v6 + 2] >> 96)).code.size));
                    v31 = address(msg.data[v6 + 2] >> 96).swap(address(v14), False, v9, address(0xfffd8963efd1fc6a506488495d951d5263988d25), v26).gas(msg.gas);
                    require(bool(v31), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                    require(RETURNDATASIZE() >= 64);
                }
            } else {
                v32 = address(msg.data[v6 + 2] >> 96);
                v33 = 0x1282(msg.data[v6 + 2] >> 96, v9, 1);
                v34 = new bytes[](v17.length);
                v35 = v36 = v34.data;
                v37 = v17.length;
                v38 = v39 = v17.data;
                if (0 < v37) {
                    v40 = v17.data;
                    v41 = v34.data;
                    v34[0] = v17[0];
                    v42 = 32;
                }
            }
        } else {
            v32 = v43 = address(msg.data[v6 + 2] >> 96);
            v44 = 0x1282(msg.data[v6 + 2] >> 96, v9, 0);
            v45 = new bytes[](v17.length);
            v35 = v46 = v45.data;
            v37 = v47 = v17.length;
            v38 = v48 = v17.data;
            v42 = v49 = 0;
        }
        while (v42 < v37) {
            MEM[v42 + v35] = MEM[v42 + v38];
            v42 += 32;
        }
        v50 = v51 = v37 + v35;
        if (0x1f & v37) {
            MEM[v51 - (0x1f & v37)] = ~((uint8.max + 1) ** (32 - (0x1f & v37)) - 1) & MEM[v51 - (0x1f & v37)];
        }
        require(bool(v32.code.size));
        v52 = v32.swap(uint32(0x22c0d9f), v44, 0, 0, v33, address(this), address(this), v45, v34).gas(msg.gas);
        require(bool(v52), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        0x1892(0, msg.gas);
    }
}

function 0x10b2(uint256 varg0, address varg1, address varg2) private { 
    MEM[64] = MEM[64] + 100;
    v0 = v1 = MEM[64] + 32;
    v2 = v3 = MEM[64];
    while (v4 >= 32) {
        MEM[v2] = MEM[v0];
        v4 = v4 - 32;
        v2 += 32;
        v0 += 32;
    }
    MEM[v2] = MEM[v0] & ~((uint8.max + 1) ** (32 - v4) - 1) | MEM[v2] & (uint8.max + 1) ** (32 - v4) - 1;
    v5, /* uint256 */ v6 = varg2.transfer(varg1, varg0).gas(msg.gas);
    if (RETURNDATASIZE() != 0) {
        v7 = new bytes[](RETURNDATASIZE());
        v6 = v7.data;
        RETURNDATACOPY(v6, 0, RETURNDATASIZE());
    }
    require(v5, Error('Oopsie'));
    return ;
}

function 0x56eff5b7() public nonPayable {  find similar
    v0 = v1 = 4;
    require(msg.gas >= 0x124f8 * (msg.data.length - v1) / 28, Error(0x6e6f20676173));
    v2, v3 = 0x1a30(v1);
    require(0 != v3, Error(0x6e6f206f7070));
    require(msg.gas >= 0x124f8 * (msg.data.length - v1) / 28, Error(0x6e6f20676173));
    v4 = v5 = 32;
    if (!v2) {
        v0 = msg.data.length - 28;
        v4 = msg.data.length - 56;
    }
    v6 = v7 = msg.data[v0] >> 248;
    v8 = v9 = this;
    if (msg.data[v4] >> 248 < 2) {
        v8 = v10 = msg.data[v4 + 2] >> 96;
    }
    require(msg.data.length - v1 + 17 <= uint64.max);
    v11 = new bytes[](msg.data.length - v1 + 17);
    if (msg.data.length - v1 + 17) {
        CALLDATACOPY(v11.data, msg.data.length, msg.data.length - v1 + 17);
    }
    CALLDATACOPY(v11.data, v1, msg.data.length - v1);
    v11[msg.data.length - v1] = (v3 << 128) + (v2 << 120);
    if (!v2) {
        if (v7 % 2) {
            v6 = v12 = v7 - 1;
        } else {
            v6 = v13 = v7 + 1;
        }
    }
    if (v6) {
        if (1 != v6) {
            if (2 != v6) {
                v14 = new bytes[](v11.length);
                v15 = v16 = 0;
                while (v15 < v11.length) {
                    v14[v15] = v11[v15];
                    v15 += 32;
                }
                v17 = v18 = v11.length + v14.data;
                if (0x1f & v11.length) {
                    MEM[v18 - (0x1f & v11.length)] = ~((uint8.max + 1) ** (32 - (0x1f & v11.length)) - 1) & MEM[v18 - (0x1f & v11.length)];
                }
                require(bool((address(msg.data[v0 + 2] >> 96)).code.size));
                v19 = address(msg.data[v0 + 2] >> 96).swap(address(v8), True, v3, address(0x1000276a4), v14).gas(msg.gas);
                require(bool(v19), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                require(RETURNDATASIZE() >= 64);
            } else {
                v20 = new bytes[](v11.length);
                v21 = v22 = 0;
                while (v21 < v11.length) {
                    v20[v21] = v11[v21];
                    v21 += 32;
                }
                v23 = v24 = v11.length + v20.data;
                if (0x1f & v11.length) {
                    MEM[v24 - (0x1f & v11.length)] = ~((uint8.max + 1) ** (32 - (0x1f & v11.length)) - 1) & MEM[v24 - (0x1f & v11.length)];
                }
                require(bool((address(msg.data[v0 + 2] >> 96)).code.size));
                v25 = address(msg.data[v0 + 2] >> 96).swap(address(v8), False, v3, address(0xfffd8963efd1fc6a506488495d951d5263988d25), v20).gas(msg.gas);
                require(bool(v25), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                require(RETURNDATASIZE() >= 64);
            }
        } else {
            v26 = address(msg.data[v0 + 2] >> 96);
            v27 = 0x1282(msg.data[v0 + 2] >> 96, v3, 1);
            v28 = new bytes[](v11.length);
            v29 = v30 = v28.data;
            v31 = v11.length;
            v32 = v33 = v11.data;
            if (0 < v31) {
                v34 = v11.data;
                v35 = v28.data;
                v28[0] = v11[0];
                v36 = 32;
            }
        }
    } else {
        v26 = v37 = address(msg.data[v0 + 2] >> 96);
        v38 = 0x1282(msg.data[v0 + 2] >> 96, v3, 0);
        v39 = new bytes[](v11.length);
        v29 = v40 = v39.data;
        v31 = v41 = v11.length;
        v32 = v42 = v11.data;
        v36 = v43 = 0;
    }
    while (v36 < v31) {
        MEM[v36 + v29] = MEM[v36 + v32];
        v36 += 32;
    }
    v44 = v45 = v31 + v29;
    if (0x1f & v31) {
        MEM[v45 - (0x1f & v31)] = ~((uint8.max + 1) ** (32 - (0x1f & v31)) - 1) & MEM[v45 - (0x1f & v31)];
    }
    require(bool(v26.code.size));
    v46 = v26.swap(uint32(0x22c0d9f), v38, 0, 0, v27, address(this), address(this), v39, v28).gas(msg.gas);
    require(bool(v46), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(bool(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.code.size));
    v47, /* uint256 */ v48 = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.balanceOf(this).gas(msg.gas);
    require(bool(v47), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(RETURNDATASIZE() >= 32);
    require(bool(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.code.size));
    v49 = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.withdraw(v48).gas(msg.gas);
    require(bool(v49), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
}

function withdrawERCTo(address varg0, address varg1, uint256 varg2) public nonPayable {  find similar
    require(msg.data.length - 4 >= 96);
    require(0xf90029931c7a9a27e350cd35c91cbedbb58350c4 == msg.sender);
    0x10b2(varg2, varg0, varg1);
}

function 0x1282(address varg0, uint256 varg1, uint256 varg2) private { 
    require(bool(varg0.code.size));
    v0, /* uint112 */ v1, /* uint112 */ v2 = varg0.getReserves().gas(msg.gas);
    require(bool(v0), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(RETURNDATASIZE() >= 96);
    v3 = v4 = uint112(v1);
    v3 = v5 = uint112(v2);
    assert(1000 * v3 + 997 * varg1);
    return 997 * varg1 * v3 / (1000 * v3 + 997 * varg1);
}

function 0x96ce0a56(address varg0, address varg1) public payable {  find similar
    require(msg.data.length - 4 >= 64);
    require(bool(varg0.code.size));
    v0, /* uint256 */ v1 = varg0.balanceOf(address(this)).gas(msg.gas);
    require(bool(v0), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(RETURNDATASIZE() >= 32);
    require(bool(varg0.code.size));
    v2, /* uint256 */ v3 = varg0.balanceOf(varg1).gas(msg.gas);
    require(bool(v2), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(RETURNDATASIZE() >= 32);
    v4 = varg0.transfer(varg1, v1).gas(msg.gas);
    require(v4, fallback(0));
    require(bool(varg0.code.size));
    v5, /* uint256 */ v6 = varg0.balanceOf(varg1).gas(msg.gas);
    require(bool(v5), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    require(RETURNDATASIZE() >= 32);
    require(v6 <= v3, v6 - v3);
    revert(fallback(0));
}

function 0x1892(uint256 varg0, uint256 varg1) private { 
    if (!varg0) {
        require(bool(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.code.size));
        v0, /* uint256 */ varg0 = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.balanceOf(this).gas(msg.gas);
        require(bool(v0), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        require(RETURNDATASIZE() >= 32);
        require(bool(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.code.size));
        v1 = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.withdraw(varg0).gas(msg.gas);
        require(bool(v1), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
    }
    require(msg.value < 1000);
    if (msg.value) {
        require(varg0 > msg.gas * (varg1 - msg.gas + ((msg.data.length << 4) + 29500)), Error('Unprofitable'));
        v2 = (varg0 - msg.gas * (varg1 - msg.gas + ((msg.data.length << 4) + 29500))) * msg.value / 1000;
        v3 = block.coinbase.call().value(v2).gas(2300 * !v2);
        require(bool(v3), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
        return ;
    } else {
        return ;
    }
}

function 0x1a30(uint256 varg0) private { 
    v0 = (msg.data.length - varg0) / 28;
    v1 = new struct(6);
    v1.word0 = 0;
    v1.word1 = False;
    v1.word2 = 96;
    v2 = new struct(3);
    v2.word0 = address(0x0);
    v2.word1 = 0;
    v2.word2 = 0;
    v1.word3 = v2;
    v3 = 0x3436();
    v1.word4 = v3;
    v1.word5 = 0;
    v1.word0 = varg0;
    v1.word1 = 1;
    require(v0 <= uint64.max);
    v4 = new uint256[](v0);
    if (v0) {
        CALLDATACOPY(v4.data, msg.data.length, v0 << 5);
    }
    v1.word2 = v4;
    assert(3);
    v1.word5 = msg.gas / 3;
    v5 = v6 = v7.data;
    while (varg0 < msg.data.length) {
        assert(varg0 < msg.data.length);
        if (bytes1(msg.data[varg0] >> 248 << 248) >= 0x200000000000000000000000000000000000000000000000000000000000000) {
            v8 = 0x3436();
            v9 = 0x3436();
            v9.word0 = msg.data[varg0 + 2] >> 96;
            v9.word1 = msg.data[varg0 + 22] >> 232;
            v9.word2 = msg.data[varg0 + 25] >> 232;
            assert(varg0 < msg.data.length);
            v9.word3 = 0x300000000000000000000000000000000000000000000000000000000000000 == bytes1(msg.data[varg0]);
            v9.word4 = int16.min;
            MEM[MEM[64]] = 0x3850c7bd00000000000000000000000000000000000000000000000000000000;
            require(bool((address(v9.word0)).code.size));
            v10 = address(v9.word0).staticcall(MEM[MEM[64]:MEM[64] + 4], MEM[MEM[64]:MEM[64] + 224]).gas(msg.gas);
            if (bool(v10)) {
                require(RETURNDATASIZE() >= 224);
                MEM[v9.word8] = int24(MEM[32 + MEM[64]]);
                MEM[32 + v9.word8] = address(MEM[MEM[64]]);
                MEM[MEM[64]] = 0x1a68650200000000000000000000000000000000000000000000000000000000;
                require(bool((address(v9.word0)).code.size));
                v11 = address(v9.word0).staticcall(MEM[MEM[64]:MEM[64] + 4], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                if (bool(v11)) {
                    require(RETURNDATASIZE() >= 32);
                    MEM[v9.word8 + 64] = uint128(MEM[MEM[64]]);
                    assert(int24(v9.word2));
                    if (int24(int24(MEM[v9.word8]) % int24(v9.word2))) {
                        if (int24(MEM[v9.word8]) <= 0) {
                            assert(int24(v9.word2));
                            MEM[v9.word8] = int24((int24(MEM[v9.word8]) / int24(v9.word2) - 1) * v9.word2);
                        } else {
                            assert(int24(v9.word2));
                            MEM[v9.word8] = int24(int24(MEM[v9.word8]) / int24(v9.word2) * v9.word2);
                        }
                    }
                    MEM[v5] = v9;
                } else {
                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                    revert(0, RETURNDATASIZE());
                }
            } else {
                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                revert(0, RETURNDATASIZE());
            }
        } else {
            MEM[MEM[64]] = address(0x0);
            MEM[32 + MEM[64]] = 0;
            MEM[64 + MEM[64]] = 0;
            v12 = new struct(3);
            v12.word0 = address(0x0);
            v12.word1 = 0;
            v12.word2 = 0;
            v12.word0 = msg.data[varg0 + 2] >> 96;
            require(bool((address(v12.word0)).code.size));
            v13 = address(v12.word0).getReserves().gas(msg.gas);
            if (bool(v13)) {
                require(RETURNDATASIZE() >= 96);
                assert(varg0 < msg.data.length);
                if (bool(bytes1(msg.data[varg0]))) {
                    v12.word1 = uint112(MEM[MEM[64]]);
                    v12.word2 = uint112(MEM[MEM[64] + 32]);
                } else {
                    v12.word1 = uint112(MEM[MEM[64] + 32]);
                    v12.word2 = uint112(MEM[MEM[64]]);
                }
                MEM[v5] = v12;
            } else {
                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                revert(0, RETURNDATASIZE());
            }
        }
        varg0 += 28;
        v5 += 32;
    }
    v14 = v15 = 10 ** 15;
    v16 = v17 = 0x1fa4(v1, v15);
    if (v17 < v15) {
        v18 = v19 = 0;
        v1.word1 = v19;
        v20 = v21 = v22.data;
        while (v18 < v0) {
            assert(v18 * 28 + v1.word0 < msg.data.length);
            if (bytes1(msg.data[v18 * 28 + v1.word0] >> 248 << 248) >= 0x200000000000000000000000000000000000000000000000000000000000000) {
                v1.word4 = MEM[v20];
                MEM[96 + MEM[v20]] = !MEM[96 + MEM[v20]];
                MEM[MEM[uint8.max + 1 + v1.word4] + 160] = 0;
                MEM[96 + MEM[v1.word4 + (uint8.max + 1)]] = 0;
            } else {
                v1.word3 = MEM[v20];
                MEM[MEM[v20] + 32] = MEM[64 + MEM[v20]];
                MEM[64 + v1.word3] = MEM[MEM[v20] + 32];
            }
            v20 += 32;
            v18 += 1;
        }
        v16 = v23 = 0x1fa4(v1, v15);
        if (v23 < v15) {
            return 0, 0;
        }
    }
    v14 = v24 = 10 ** 17;
    v25 = v26 = 0x1fa4(v1, v24);
    v27 = v28 = v26 < v24;
    if (v26 >= v24) {
        v27 = v29 = v26 - v24 < v16 - v15;
    }
    if (!v27) {
        while (1) {
            v14 = v14 * 10;
            v25 = v30 = 0x1fa4(v1, v14);
            v31 = v32 = v30 < v14;
            if (v30 >= v14) {
                v31 = v33 = v30 - v14 < v25 - v14;
            }
            if (v31) {
                v34, v35 = v36 = 0x2126(v1, v14, v14);
                if (v34 < v0 * msg.gas * 0x124f8) {
                    v35 = v37 = 0;
                }
            }
        }
    } else {
        v38, v35 = v39 = 0x2126(v1, v24, v15);
        if (v38 < v0 * msg.gas * 0x124f8) {
            v35 = v40 = 0;
        }
    }
    return v1.word1, v35;
}

function 0x1fa4(struct(6) varg0, uint256 varg1) private { 
    if (!varg0.word1) {
        v0 = varg0.word2;
        v1 = v2 = (v3.length << 5) + varg0.word2;
        v4 = v5 = v3.length - 1;
        while (v4 < v3.length) {
            assert(v4 * 28 + varg0.word0 < msg.data.length);
            if (bytes1(msg.data[v4 * 28 + varg0.word0] >> 248 << 248) >= 0x200000000000000000000000000000000000000000000000000000000000000) {
                varg0.word4 = MEM[v1];
                MEM[MEM[v1] + 192] = varg0.word5;
                v6 = varg0.word4;
                v7 = v8 = MEM[v6 + (uint8.max + 1)];
                varg1 = v9 = 0;
                v10 = v11 = !MEM[v8 + 160];
                if (bool(MEM[v8 + 160])) {
                    v7 = v12 = MEM[v6 + 224];
                    if (varg1 <= MEM[96 + v12]) {
                        v7 = v13 = MEM[uint8.max + 1 + v6];
                        while (varg1 <= MEM[96 + v7]) {
                            varg1 = varg1 - MEM[96 + v7];
                            varg1 = v14 = MEM[128 + v7];
                            v7 = v15 = MEM[v7 + 160];
                        }
                    } else {
                        varg1 = varg1 - MEM[96 + v12];
                        varg1 = v16 = MEM[128 + v12];
                    }
                } else {
                    if (!MEM[v8 + 96]) {
                        if (!MEM[96 + v6]) {
                            v17 = v18 = 0x2584(MEM[v6 + 64] + MEM[v8]);
                        } else {
                            v17 = 0x2584(MEM[v8]);
                        }
                        v19, v20 = 0x287a(MEM[32 + v6], v17, MEM[32 + v8], MEM[64 + v8]);
                        MEM[v8 + 96] = v20;
                    }
                    if (MEM[96 + v8] >= varg1) {
                        varg1 = 0x2907(MEM[32 + v6], MEM[32 + v8], MEM[64 + v8], varg1, MEM[96 + v6]);
                    }
                }
                varg0.word5 = MEM[192 + varg0.word4];
                while (1) {
                    if (MEM[v7 + 160]) {
                        // Unknown jump to Block 0x2417B0x20d4. Refer to 3-address code (TAC);
                    }
                    v21 = new struct(6);
                    v21.word0 = int24(0);
                    v21.word1 = address(0x0);
                    v21.word2 = uint128(0);
                    v21.word3 = 0;
                    v21.word4 = 0;
                    v21.word5 = 0;
                    v10 = v22 = !MEM[96 + v6];
                    if (!v10) {
                        assert(int24(MEM[64 + v6]));
                        v23 = v24 = int24(MEM[v7] - MEM[64 + v6]) / int24(MEM[64 + v6]);
                        if (!MEM[96 + v6]) {
                            if (MEM[192 + v6] <= 0x1c9c380) {
                                v25 = v26 = 1 + v24;
                                v27 = int24(v26) % (uint8.max + 1);
                                if (int16(int24(v26) >> 8) != int16(MEM[128 + v6])) {
                                    MEM[v6 + 128] = int16(int24(v26) >> 8);
                                    MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                    MEM[MEM[64] + 4] = int16(int24(v26) >> 8);
                                    require(bool((address(MEM[v6])).code.size));
                                    v28 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                    if (bool(v28)) {
                                        require(RETURNDATASIZE() >= 32);
                                        MEM[v6 + 160] = MEM[MEM[64]];
                                        MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                    } else {
                                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                        revert(0, RETURNDATASIZE());
                                    }
                                }
                                v29 = v30 = ~((1 << uint8(v27)) - 1) & MEM[v6 + 160];
                                if (!v30) {
                                    assert(int24(MEM[v6 + 64]));
                                    while (1) {
                                        v31 = v32 = !v29;
                                        if (bool(v29)) {
                                            // Unknown jump to Block 0x2d16B0x239dB0x20d4. Refer to 3-address code (TAC);
                                        }
                                        v31 = v33 = int16(MEM[128 + v6]) < int16(int24(0xd89e8 / int24(MEM[v6 + 64])) >> 8);
                                        if (v31) {
                                            v31 = MEM[192 + v6] < 0x1c9c380;
                                        }
                                        if (!v31) {
                                            v25 = v34 = int16(MEM[128 + v6]) << 8;
                                        } else {
                                            MEM[v6 + 128] = int16(1 + MEM[v6 + 128]);
                                            MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                            MEM[MEM[64] + 4] = int16(1 + MEM[v6 + 128]);
                                            require(bool((address(MEM[v6])).code.size));
                                            v35 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                            if (bool(v35)) {
                                                require(RETURNDATASIZE() >= 32);
                                                v29 = v36 = MEM[MEM[64]];
                                                MEM[v6 + 160] = v36;
                                                MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                                v27 = v37 = 0;
                                            } else {
                                                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                                revert(0, RETURNDATASIZE());
                                            }
                                        }
                                    }
                                }
                                if (v29) {
                                    v38 = 0x312b(v29);
                                    v39 = v40 = (v25 + uint8(v38 - v27)) * MEM[64 + v6];
                                } else {
                                    v39 = 0xd89e8;
                                }
                            } else {
                                v39 = v41 = 0xd89e8;
                            }
                        } else if (MEM[192 + v6] <= 0x1c9c380) {
                            v42 = int24(v24) % (uint8.max + 1);
                            if (int16(int24(v24) >> 8) != int16(MEM[128 + v6])) {
                                MEM[v6 + 128] = int16(int24(v24) >> 8);
                                MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                MEM[MEM[64] + 4] = int16(int24(v24) >> 8);
                                require(bool((address(MEM[v6])).code.size));
                                v43 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                if (bool(v43)) {
                                    require(RETURNDATASIZE() >= 32);
                                    MEM[v6 + 160] = MEM[MEM[64]];
                                    MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                            v44 = v45 = uint256.max + ((1 << uint8(v42)) + (1 << uint8(v42))) & MEM[v6 + 160];
                            if (!v45) {
                                assert(int24(MEM[v6 + 64]));
                                v46 = v47 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 / int24(MEM[v6 + 64]);
                                assert(int24(MEM[64 + v6]));
                                if (int24(int24(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618) % int24(MEM[64 + v6]))) {
                                    v46 = v48 = uint256.max + v47;
                                }
                                while (1) {
                                    v49 = v50 = !v44;
                                    if (bool(v44)) {
                                        // Unknown jump to Block 0x2adcB0x239dB0x20d4. Refer to 3-address code (TAC);
                                    }
                                    v49 = v51 = int16(MEM[128 + v6]) > int16(int24(v46) >> 8);
                                    if (v49) {
                                        v49 = MEM[192 + v6] < 0x1c9c380;
                                    }
                                    if (!v49) {
                                        v23 = v52 = uint8.max + (int16(MEM[128 + v6]) << 8);
                                    } else {
                                        MEM[v6 + 128] = int16(uint256.max + MEM[v6 + 128]);
                                        MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                        MEM[MEM[64] + 4] = int16(uint256.max + MEM[v6 + 128]);
                                        require(bool((address(MEM[v6])).code.size));
                                        v53 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                        if (bool(v53)) {
                                            require(RETURNDATASIZE() >= 32);
                                            v44 = v54 = MEM[MEM[64]];
                                            MEM[v6 + 160] = v54;
                                            MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                            v42 = v55 = uint8.max;
                                        } else {
                                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                            revert(0, RETURNDATASIZE());
                                        }
                                    }
                                }
                            }
                            if (v44) {
                                v56 = 0x308b(v44);
                                v39 = v57 = (v23 - uint8(v42 - v56)) * MEM[64 + v6];
                            } else {
                                v39 = v58 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                            }
                        } else {
                            v39 = v59 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                        }
                        v21.word0 = int24(v39);
                    } else {
                        v10 = v60 = 0;
                        assert(int24(MEM[64 + v6]));
                        v61 = v62 = int24(MEM[v7]) / int24(MEM[64 + v6]);
                        if (!MEM[96 + v6]) {
                            if (MEM[192 + v6] <= 0x1c9c380) {
                                v63 = v64 = 1 + v62;
                                v65 = int24(v64) % (uint8.max + 1);
                                if (int16(int24(v64) >> 8) != int16(MEM[128 + v6])) {
                                    MEM[v6 + 128] = int16(int24(v64) >> 8);
                                    MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                    MEM[MEM[64] + 4] = int16(int24(v64) >> 8);
                                    require(bool((address(MEM[v6])).code.size));
                                    v66 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                    if (bool(v66)) {
                                        require(RETURNDATASIZE() >= 32);
                                        MEM[v6 + 160] = MEM[MEM[64]];
                                        MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                    } else {
                                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                        revert(0, RETURNDATASIZE());
                                    }
                                }
                                v67 = v68 = ~((1 << uint8(v65)) - 1) & MEM[v6 + 160];
                                if (!v68) {
                                    assert(int24(MEM[v6 + 64]));
                                    while (1) {
                                        v69 = v70 = !v67;
                                        if (bool(v67)) {
                                            // Unknown jump to Block 0x2d16B0x237eB0x20d4. Refer to 3-address code (TAC);
                                        }
                                        v69 = v71 = int16(MEM[128 + v6]) < int16(int24(0xd89e8 / int24(MEM[v6 + 64])) >> 8);
                                        if (v69) {
                                            v69 = MEM[192 + v6] < 0x1c9c380;
                                        }
                                        if (!v69) {
                                            v63 = v72 = int16(MEM[128 + v6]) << 8;
                                        } else {
                                            MEM[v6 + 128] = int16(1 + MEM[v6 + 128]);
                                            MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                            MEM[MEM[64] + 4] = int16(1 + MEM[v6 + 128]);
                                            require(bool((address(MEM[v6])).code.size));
                                            v73 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                            if (bool(v73)) {
                                                require(RETURNDATASIZE() >= 32);
                                                v67 = v74 = MEM[MEM[64]];
                                                MEM[v6 + 160] = v74;
                                                MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                                v65 = v75 = 0;
                                            } else {
                                                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                                revert(0, RETURNDATASIZE());
                                            }
                                        }
                                    }
                                }
                                if (v67) {
                                    v76 = 0x312b(v67);
                                    v77 = v78 = (v63 + uint8(v76 - v65)) * MEM[64 + v6];
                                } else {
                                    v77 = 0xd89e8;
                                }
                            } else {
                                v77 = v79 = 0xd89e8;
                            }
                        } else if (MEM[192 + v6] <= 0x1c9c380) {
                            v80 = int24(v62) % (uint8.max + 1);
                            if (int16(int24(v62) >> 8) != int16(MEM[128 + v6])) {
                                MEM[v6 + 128] = int16(int24(v62) >> 8);
                                MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                MEM[MEM[64] + 4] = int16(int24(v62) >> 8);
                                require(bool((address(MEM[v6])).code.size));
                                v81 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                if (bool(v81)) {
                                    require(RETURNDATASIZE() >= 32);
                                    MEM[v6 + 160] = MEM[MEM[64]];
                                    MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                            v82 = v83 = uint256.max + ((1 << uint8(v80)) + (1 << uint8(v80))) & MEM[v6 + 160];
                            if (!v83) {
                                assert(int24(MEM[v6 + 64]));
                                v84 = v85 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 / int24(MEM[v6 + 64]);
                                assert(int24(MEM[64 + v6]));
                                if (int24(int24(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618) % int24(MEM[64 + v6]))) {
                                    v84 = v86 = uint256.max + v85;
                                }
                                while (1) {
                                    v87 = v88 = !v82;
                                    if (bool(v82)) {
                                        // Unknown jump to Block 0x2adcB0x237eB0x20d4. Refer to 3-address code (TAC);
                                    }
                                    v87 = v89 = int16(MEM[128 + v6]) > int16(int24(v84) >> 8);
                                    if (v87) {
                                        v87 = MEM[192 + v6] < 0x1c9c380;
                                    }
                                    if (!v87) {
                                        v61 = v90 = uint8.max + (int16(MEM[128 + v6]) << 8);
                                    } else {
                                        MEM[v6 + 128] = int16(uint256.max + MEM[v6 + 128]);
                                        MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                        MEM[MEM[64] + 4] = int16(uint256.max + MEM[v6 + 128]);
                                        require(bool((address(MEM[v6])).code.size));
                                        v91 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                        if (bool(v91)) {
                                            require(RETURNDATASIZE() >= 32);
                                            v82 = v92 = MEM[MEM[64]];
                                            MEM[v6 + 160] = v92;
                                            MEM[v6 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                            v80 = v93 = uint8.max;
                                        } else {
                                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                            revert(0, RETURNDATASIZE());
                                        }
                                    }
                                }
                            }
                            if (v82) {
                                v94 = 0x308b(v82);
                                v77 = v95 = (v61 - uint8(v80 - v94)) * MEM[64 + v6];
                            } else {
                                v77 = v96 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                            }
                        } else {
                            v77 = v97 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                        }
                        v21.word0 = int24(v77);
                    }
                    v98 = 0x2584(v21.word0);
                    v21.word1 = address(v98);
                    v99, v100 = 0x287a(MEM[v6 + 32], address(v98), MEM[32 + v7], MEM[v7 + 64]);
                    MEM[v7 + 96] = v100 + (varg1 - varg1);
                    MEM[v7 + 128] = varg1 + v99;
                    MEM[v6 + 224] = v7;
                    MEM[v7 + 160] = v21;
                    if (MEM[96 + v7] < varg1) {
                        varg1 = v101 = MEM[v7 + 128];
                        v7 = v102 = MEM[v7 + 160];
                        varg1 = varg1 - MEM[v7 + 96];
                        if (0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 != int24(MEM[v102])) {
                            v103 = v104 = 0xd89e8 == int24(MEM[v102]);
                            if (v104) {
                                v103 = !MEM[96 + v6];
                            }
                            if (!v103) {
                                MEM[MEM[64]] = 0xf30dba9300000000000000000000000000000000000000000000000000000000;
                                MEM[4 + MEM[64]] = int24(MEM[v102]);
                                require(bool((address(MEM[v6])).code.size));
                                v105 = address(MEM[v6]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + uint8.max + 1]).gas(msg.gas);
                                if (bool(v105)) {
                                    require(RETURNDATASIZE() >= uint8.max + 1);
                                    v106 = v107 = MEM[32 + MEM[64]];
                                    MEM[v6 + 192] += 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8f0;
                                    if (MEM[v6 + 96]) {
                                        v106 = v108 = 0 - v107;
                                    }
                                    if (int128(v106) >= 0) {
                                        v109 = v110 = v106 + MEM[v7 + 64];
                                    } else {
                                        v109 = MEM[v7 + 64] - (0 - v106);
                                    }
                                    MEM[v102 + 64] = uint128(v109);
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                        }
                    } else {
                        v111 = 0x2907(MEM[32 + v6], MEM[32 + v7], MEM[64 + v7], varg1, MEM[96 + v6]);
                        varg1 = varg1 + v111;
                    }
                }
            } else {
                varg0.word3 = MEM[v1];
                assert(1000 * MEM[32 + varg0.word3] + 997 * varg1);
                varg1 = 997 * varg1 * MEM[64 + varg0.word3] / (1000 * MEM[32 + varg0.word3] + 997 * varg1);
            }
            v1 = v1 - 32;
            v4 += uint256.max;
        }
    } else {
        v112 = v113 = v114.data;
        v115 = v116 = 0;
        while (v115 < v3.length) {
            assert(v115 * 28 + varg0.word0 < msg.data.length);
            if (bytes1(msg.data[v115 * 28 + varg0.word0] >> 248 << 248) >= 0x200000000000000000000000000000000000000000000000000000000000000) {
                varg0.word4 = MEM[v112];
                MEM[MEM[v112] + 192] = varg0.word5;
                v117 = varg0.word4;
                v118 = v119 = MEM[v117 + (uint8.max + 1)];
                varg1 = v120 = 0;
                v121 = v122 = !MEM[v119 + 160];
                if (bool(MEM[v119 + 160])) {
                    v118 = v123 = MEM[v117 + 224];
                    if (varg1 <= MEM[96 + v123]) {
                        v118 = v124 = MEM[uint8.max + 1 + v117];
                        while (varg1 <= MEM[96 + v118]) {
                            varg1 = varg1 - MEM[96 + v118];
                            varg1 = v125 = MEM[128 + v118];
                            v118 = v126 = MEM[v118 + 160];
                        }
                    } else {
                        varg1 = varg1 - MEM[96 + v123];
                        varg1 = v127 = MEM[128 + v123];
                    }
                } else {
                    if (!MEM[v119 + 96]) {
                        if (!MEM[96 + v117]) {
                            v128 = v129 = 0x2584(MEM[v117 + 64] + MEM[v119]);
                        } else {
                            v128 = 0x2584(MEM[v119]);
                        }
                        v130, v131 = 0x287a(MEM[32 + v117], v128, MEM[32 + v119], MEM[64 + v119]);
                        MEM[v119 + 96] = v131;
                    }
                    if (MEM[96 + v119] >= varg1) {
                        varg1 = 0x2907(MEM[32 + v117], MEM[32 + v119], MEM[64 + v119], varg1, MEM[96 + v117]);
                    }
                }
                varg0.word5 = MEM[192 + varg0.word4];
                while (1) {
                    if (MEM[v118 + 160]) {
                        // Unknown jump to Block 0x2417B0x2020. Refer to 3-address code (TAC);
                    }
                    v132 = new struct(6);
                    v132.word0 = int24(0);
                    v132.word1 = address(0x0);
                    v132.word2 = uint128(0);
                    v132.word3 = 0;
                    v132.word4 = 0;
                    v132.word5 = 0;
                    v121 = v133 = !MEM[96 + v117];
                    if (!v121) {
                        assert(int24(MEM[64 + v117]));
                        v134 = v135 = int24(MEM[v118] - MEM[64 + v117]) / int24(MEM[64 + v117]);
                        if (!MEM[96 + v117]) {
                            if (MEM[192 + v117] <= 0x1c9c380) {
                                v136 = v137 = 1 + v135;
                                v138 = int24(v137) % (uint8.max + 1);
                                if (int16(int24(v137) >> 8) != int16(MEM[128 + v117])) {
                                    MEM[v117 + 128] = int16(int24(v137) >> 8);
                                    MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                    MEM[MEM[64] + 4] = int16(int24(v137) >> 8);
                                    require(bool((address(MEM[v117])).code.size));
                                    v139 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                    if (bool(v139)) {
                                        require(RETURNDATASIZE() >= 32);
                                        MEM[v117 + 160] = MEM[MEM[64]];
                                        MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                    } else {
                                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                        revert(0, RETURNDATASIZE());
                                    }
                                }
                                v140 = v141 = ~((1 << uint8(v138)) - 1) & MEM[v117 + 160];
                                if (!v141) {
                                    assert(int24(MEM[v117 + 64]));
                                    while (1) {
                                        v142 = v143 = !v140;
                                        if (bool(v140)) {
                                            // Unknown jump to Block 0x2d16B0x239dB0x2020. Refer to 3-address code (TAC);
                                        }
                                        v142 = v144 = int16(MEM[128 + v117]) < int16(int24(0xd89e8 / int24(MEM[v117 + 64])) >> 8);
                                        if (v142) {
                                            v142 = MEM[192 + v117] < 0x1c9c380;
                                        }
                                        if (!v142) {
                                            v136 = v145 = int16(MEM[128 + v117]) << 8;
                                        } else {
                                            MEM[v117 + 128] = int16(1 + MEM[v117 + 128]);
                                            MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                            MEM[MEM[64] + 4] = int16(1 + MEM[v117 + 128]);
                                            require(bool((address(MEM[v117])).code.size));
                                            v146 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                            if (bool(v146)) {
                                                require(RETURNDATASIZE() >= 32);
                                                v140 = v147 = MEM[MEM[64]];
                                                MEM[v117 + 160] = v147;
                                                MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                                v138 = v148 = 0;
                                            } else {
                                                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                                revert(0, RETURNDATASIZE());
                                            }
                                        }
                                    }
                                }
                                if (v140) {
                                    v149 = 0x312b(v140);
                                    v150 = v151 = (v136 + uint8(v149 - v138)) * MEM[64 + v117];
                                } else {
                                    v150 = 0xd89e8;
                                }
                            } else {
                                v150 = v152 = 0xd89e8;
                            }
                        } else if (MEM[192 + v117] <= 0x1c9c380) {
                            v153 = int24(v135) % (uint8.max + 1);
                            if (int16(int24(v135) >> 8) != int16(MEM[128 + v117])) {
                                MEM[v117 + 128] = int16(int24(v135) >> 8);
                                MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                MEM[MEM[64] + 4] = int16(int24(v135) >> 8);
                                require(bool((address(MEM[v117])).code.size));
                                v154 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                if (bool(v154)) {
                                    require(RETURNDATASIZE() >= 32);
                                    MEM[v117 + 160] = MEM[MEM[64]];
                                    MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                            v155 = v156 = uint256.max + ((1 << uint8(v153)) + (1 << uint8(v153))) & MEM[v117 + 160];
                            if (!v156) {
                                assert(int24(MEM[v117 + 64]));
                                v157 = v158 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 / int24(MEM[v117 + 64]);
                                assert(int24(MEM[64 + v117]));
                                if (int24(int24(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618) % int24(MEM[64 + v117]))) {
                                    v157 = v159 = uint256.max + v158;
                                }
                                while (1) {
                                    v160 = v161 = !v155;
                                    if (bool(v155)) {
                                        // Unknown jump to Block 0x2adcB0x239dB0x2020. Refer to 3-address code (TAC);
                                    }
                                    v160 = v162 = int16(MEM[128 + v117]) > int16(int24(v157) >> 8);
                                    if (v160) {
                                        v160 = MEM[192 + v117] < 0x1c9c380;
                                    }
                                    if (!v160) {
                                        v134 = v163 = uint8.max + (int16(MEM[128 + v117]) << 8);
                                    } else {
                                        MEM[v117 + 128] = int16(uint256.max + MEM[v117 + 128]);
                                        MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                        MEM[MEM[64] + 4] = int16(uint256.max + MEM[v117 + 128]);
                                        require(bool((address(MEM[v117])).code.size));
                                        v164 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                        if (bool(v164)) {
                                            require(RETURNDATASIZE() >= 32);
                                            v155 = v165 = MEM[MEM[64]];
                                            MEM[v117 + 160] = v165;
                                            MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                            v153 = v166 = uint8.max;
                                        } else {
                                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                            revert(0, RETURNDATASIZE());
                                        }
                                    }
                                }
                            }
                            if (v155) {
                                v167 = 0x308b(v155);
                                v150 = v168 = (v134 - uint8(v153 - v167)) * MEM[64 + v117];
                            } else {
                                v150 = v169 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                            }
                        } else {
                            v150 = v170 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                        }
                        v132.word0 = int24(v150);
                    } else {
                        v121 = v171 = 0;
                        assert(int24(MEM[64 + v117]));
                        v172 = v173 = int24(MEM[v118]) / int24(MEM[64 + v117]);
                        if (!MEM[96 + v117]) {
                            if (MEM[192 + v117] <= 0x1c9c380) {
                                v174 = v175 = 1 + v173;
                                v176 = int24(v175) % (uint8.max + 1);
                                if (int16(int24(v175) >> 8) != int16(MEM[128 + v117])) {
                                    MEM[v117 + 128] = int16(int24(v175) >> 8);
                                    MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                    MEM[MEM[64] + 4] = int16(int24(v175) >> 8);
                                    require(bool((address(MEM[v117])).code.size));
                                    v177 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                    if (bool(v177)) {
                                        require(RETURNDATASIZE() >= 32);
                                        MEM[v117 + 160] = MEM[MEM[64]];
                                        MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                    } else {
                                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                        revert(0, RETURNDATASIZE());
                                    }
                                }
                                v178 = v179 = ~((1 << uint8(v176)) - 1) & MEM[v117 + 160];
                                if (!v179) {
                                    assert(int24(MEM[v117 + 64]));
                                    while (1) {
                                        v180 = v181 = !v178;
                                        if (bool(v178)) {
                                            // Unknown jump to Block 0x2d16B0x237eB0x2020. Refer to 3-address code (TAC);
                                        }
                                        v180 = v182 = int16(MEM[128 + v117]) < int16(int24(0xd89e8 / int24(MEM[v117 + 64])) >> 8);
                                        if (v180) {
                                            v180 = MEM[192 + v117] < 0x1c9c380;
                                        }
                                        if (!v180) {
                                            v174 = v183 = int16(MEM[128 + v117]) << 8;
                                        } else {
                                            MEM[v117 + 128] = int16(1 + MEM[v117 + 128]);
                                            MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                            MEM[MEM[64] + 4] = int16(1 + MEM[v117 + 128]);
                                            require(bool((address(MEM[v117])).code.size));
                                            v184 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                            if (bool(v184)) {
                                                require(RETURNDATASIZE() >= 32);
                                                v178 = v185 = MEM[MEM[64]];
                                                MEM[v117 + 160] = v185;
                                                MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                                v176 = v186 = 0;
                                            } else {
                                                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                                revert(0, RETURNDATASIZE());
                                            }
                                        }
                                    }
                                }
                                if (v178) {
                                    v187 = 0x312b(v178);
                                    v188 = v189 = (v174 + uint8(v187 - v176)) * MEM[64 + v117];
                                } else {
                                    v188 = 0xd89e8;
                                }
                            } else {
                                v188 = v190 = 0xd89e8;
                            }
                        } else if (MEM[192 + v117] <= 0x1c9c380) {
                            v191 = int24(v173) % (uint8.max + 1);
                            if (int16(int24(v173) >> 8) != int16(MEM[128 + v117])) {
                                MEM[v117 + 128] = int16(int24(v173) >> 8);
                                MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                MEM[MEM[64] + 4] = int16(int24(v173) >> 8);
                                require(bool((address(MEM[v117])).code.size));
                                v192 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                if (bool(v192)) {
                                    require(RETURNDATASIZE() >= 32);
                                    MEM[v117 + 160] = MEM[MEM[64]];
                                    MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                            v193 = v194 = uint256.max + ((1 << uint8(v191)) + (1 << uint8(v191))) & MEM[v117 + 160];
                            if (!v194) {
                                assert(int24(MEM[v117 + 64]));
                                v195 = v196 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 / int24(MEM[v117 + 64]);
                                assert(int24(MEM[64 + v117]));
                                if (int24(int24(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618) % int24(MEM[64 + v117]))) {
                                    v195 = v197 = uint256.max + v196;
                                }
                                while (1) {
                                    v198 = v199 = !v193;
                                    if (bool(v193)) {
                                        // Unknown jump to Block 0x2adcB0x237eB0x2020. Refer to 3-address code (TAC);
                                    }
                                    v198 = v200 = int16(MEM[128 + v117]) > int16(int24(v195) >> 8);
                                    if (v198) {
                                        v198 = MEM[192 + v117] < 0x1c9c380;
                                    }
                                    if (!v198) {
                                        v172 = v201 = uint8.max + (int16(MEM[128 + v117]) << 8);
                                    } else {
                                        MEM[v117 + 128] = int16(uint256.max + MEM[v117 + 128]);
                                        MEM[MEM[64]] = 0x5339c29600000000000000000000000000000000000000000000000000000000;
                                        MEM[MEM[64] + 4] = int16(uint256.max + MEM[v117 + 128]);
                                        require(bool((address(MEM[v117])).code.size));
                                        v202 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                                        if (bool(v202)) {
                                            require(RETURNDATASIZE() >= 32);
                                            v193 = v203 = MEM[MEM[64]];
                                            MEM[v117 + 160] = v203;
                                            MEM[v117 + 192] += 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff448;
                                            v191 = v204 = uint8.max;
                                        } else {
                                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                            revert(0, RETURNDATASIZE());
                                        }
                                    }
                                }
                            }
                            if (v193) {
                                v205 = 0x308b(v193);
                                v188 = v206 = (v172 - uint8(v191 - v205)) * MEM[64 + v117];
                            } else {
                                v188 = v207 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                            }
                        } else {
                            v188 = v208 = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618;
                        }
                        v132.word0 = int24(v188);
                    }
                    v209 = 0x2584(v132.word0);
                    v132.word1 = address(v209);
                    v210, v211 = 0x287a(MEM[v117 + 32], address(v209), MEM[32 + v118], MEM[v118 + 64]);
                    MEM[v118 + 96] = v211 + (varg1 - varg1);
                    MEM[v118 + 128] = varg1 + v210;
                    MEM[v117 + 224] = v118;
                    MEM[v118 + 160] = v132;
                    if (MEM[96 + v118] < varg1) {
                        varg1 = v212 = MEM[v118 + 128];
                        v118 = v213 = MEM[v118 + 160];
                        varg1 = varg1 - MEM[v118 + 96];
                        if (0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff27618 != int24(MEM[v213])) {
                            v214 = v215 = 0xd89e8 == int24(MEM[v213]);
                            if (v215) {
                                v214 = !MEM[96 + v117];
                            }
                            if (!v214) {
                                MEM[MEM[64]] = 0xf30dba9300000000000000000000000000000000000000000000000000000000;
                                MEM[4 + MEM[64]] = int24(MEM[v213]);
                                require(bool((address(MEM[v117])).code.size));
                                v216 = address(MEM[v117]).staticcall(MEM[MEM[64]:MEM[64] + 36], MEM[MEM[64]:MEM[64] + uint8.max + 1]).gas(msg.gas);
                                if (bool(v216)) {
                                    require(RETURNDATASIZE() >= uint8.max + 1);
                                    v217 = v218 = MEM[32 + MEM[64]];
                                    MEM[v117 + 192] += 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8f0;
                                    if (MEM[v117 + 96]) {
                                        v217 = v219 = 0 - v218;
                                    }
                                    if (int128(v217) >= 0) {
                                        v220 = v221 = v217 + MEM[v118 + 64];
                                    } else {
                                        v220 = MEM[v118 + 64] - (0 - v217);
                                    }
                                    MEM[v213 + 64] = uint128(v220);
                                } else {
                                    RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                    revert(0, RETURNDATASIZE());
                                }
                            }
                        }
                    } else {
                        v222 = 0x2907(MEM[32 + v117], MEM[32 + v118], MEM[64 + v118], varg1, MEM[96 + v117]);
                        varg1 = varg1 + v222;
                    }
                }
            } else {
                varg0.word3 = MEM[v112];
                assert(1000 * MEM[32 + varg0.word3] + 997 * varg1);
                varg1 = 997 * varg1 * MEM[64 + varg0.word3] / (1000 * MEM[32 + varg0.word3] + 997 * varg1);
            }
            v112 += 32;
            v115 += 1;
        }
    }
    return varg1;
}

function 0x2126(struct(6) varg0, uint256 varg1, uint256 varg2) private { 
    varg2 = v0 = varg2 + 0x96e32 * (varg1 - varg2) / 10 ** 6;
    v1 = 0x1fa4(varg0, v0);
    v2 = v3 = v1 - v0;
    v4 = v5 = 1;
    while (20 * (varg2 - varg2) >= varg2 + varg2) {
        if (!v4) {
            if (0x96e32 * (varg2 - varg2) / 10 ** 6) {
                varg2 = varg2 - 0x96e32 * (varg2 - varg2) / 10 ** 6;
                v6 = 0x1fa4(varg0, varg2);
                v2 = v7 = v6 - varg2;
                if (v7 <= v2) {
                    v4 = v8 = 1;
                }
            } else {
                break;
            }
        } else if (0x96e32 * (varg2 - varg2) / 10 ** 6) {
            varg2 += 0x96e32 * (varg2 - varg2) / 10 ** 6;
            v9 = 0x1fa4(varg0, varg2);
            v2 = v10 = v9 - varg2;
            if (v10 <= v2) {
                v4 = v11 = 0;
            }
        } else {
            break;
        }
    }
    if (v2 < 0) {
        v2 = v12 = 0;
    }
    return v2, varg2 + varg2 >> 1;
}

function 0x2584(int24 varg0) private { 
    if (varg0 < 0) {
        v0 = v1 = 0 - varg0;
    } else {
        v0 = v2 = varg0;
    }
    if (v0 & 0x1) {
        v3 = v4 = 0xfffcb933bd6fad37aa2d162d1a594001;
    } else {
        v3 = v5 = uint128.max + 1;
    }
    v6 = v7 = uint136(v3);
    if (v0 & 0x2) {
        v6 = v8 = 0xfff97272373d413259a46990580e213a * v7 >> 128;
    }
    if (v0 & 0x4) {
        v6 = v9 = 0xfff2e50f5f656932ef12357cf3c7fdcc * v6 >> 128;
    }
    if (v0 & 0x8) {
        v6 = v10 = 0xffe5caca7e10e4e61c3624eaa0941cd0 * v6 >> 128;
    }
    if (v0 & 0x10) {
        v6 = v11 = 0xffcb9843d60f6159c9db58835c926644 * v6 >> 128;
    }
    if (v0 & 0x20) {
        v6 = v12 = 0xff973b41fa98c081472e6896dfb254c0 * v6 >> 128;
    }
    if (v0 & 0x40) {
        v6 = v13 = 0xff2ea16466c96a3843ec78b326b52861 * v6 >> 128;
    }
    if (v0 & 0x80) {
        v6 = v14 = 0xfe5dee046a99a2a811c461f1969c3053 * v6 >> 128;
    }
    if (v0 & 0x100) {
        v6 = v15 = 0xfcbe86c7900a88aedcffc83b479aa3a4 * v6 >> 128;
    }
    if (v0 & 0x200) {
        v6 = v16 = 0xf987a7253ac413176f2b074cf7815e54 * v6 >> 128;
    }
    if (v0 & 0x400) {
        v6 = v17 = 0xf3392b0822b70005940c7a398e4b70f3 * v6 >> 128;
    }
    if (v0 & 0x800) {
        v6 = v18 = 0xe7159475a2c29b7443b29c7fa6e889d9 * v6 >> 128;
    }
    if (v0 & 0x1000) {
        v6 = v19 = 0xd097f3bdfd2022b8845ad8f792aa5825 * v6 >> 128;
    }
    if (v0 & 0x2000) {
        v6 = v20 = 0xa9f746462d870fdf8a65dc1f90e061e5 * v6 >> 128;
    }
    if (v0 & 0x4000) {
        v6 = v21 = 0x70d869a156d2a1b890bb3df62baf32f7 * v6 >> 128;
    }
    if (v0 & 0x8000) {
        v6 = v22 = 0x31be135f97d08fd981231505542fcfa6 * v6 >> 128;
    }
    if (v0 & 0x10000) {
        v6 = v23 = 0x9aa508b5b7a84e1c677de54f3e99bc9 * v6 >> 128;
    }
    if (v0 & 0x20000) {
        v6 = v24 = 0x5d6af8dedb81196699c329225ee604 * v6 >> 128;
    }
    if (v0 & 0x40000) {
        v6 = v25 = 0x2216e584f5fa1ea926041bedfe98 * v6 >> 128;
    }
    if (v0 & 0x80000) {
        v6 = v26 = 0x48a170391f7dc42444e8fa2 * v6 >> 128;
    }
    if (varg0 > 0) {
        assert(v6);
        v6 = v27 = uint256.max / v6;
    }
    if (!(v6 % (uint32.max + 1))) {
        v28 = v29 = 0;
    } else {
        v28 = v30 = 1;
    }
    return (v6 >> 32) + uint8(v28);
}

function 0x287a(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3) private { 
    if (address(varg1) <= address(varg2)) {
        v0 = v1 = 0x2e99(1, varg3, varg2, varg1);
    } else {
        v0 = v2 = 0x2e1e(1, varg3, varg1, varg2);
    }
    if (address(varg1) <= address(varg2)) {
        v3 = v4 = 0x2e1e(0, varg3, varg2, varg1);
    } else {
        v3 = v5 = 0x2e99(0, varg3, varg1, varg2);
    }
    v6 = 0x2f44(uint24(10 ** 6 - varg0), uint24(varg0), v0);
    return v3, v0 + v6;
}

function 0x2907(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3, uint256 varg4) private { 
    v0 = 0x2f7e(10 ** 6, uint24(10 ** 6 - varg0), varg3);
    v1 = 0x302d(varg4, v0, varg2, varg1);
    if (!varg4) {
        v2 = v3 = 0x2e99(0, varg2, v1, varg1);
    } else {
        v2 = v4 = 0x2e1e(0, varg2, varg1, v1);
    }
    return v2;
}

function 0x2e1e(uint256 varg0, uint128 varg1, uint256 varg2, uint256 varg3) private { 
    if (varg0) {
        v0 = 0x2f44(uint96.max + 1, address(varg3 - varg3), varg1);
        return v0;
    } else {
        v1 = 0x2f7e(uint96.max + 1, address(varg3 - varg3), varg1);
        return v1;
    }
}

function 0x2e99(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3) private { 
    v0 = address(varg3 - varg3);
    require(address(varg3));
    if (varg0) {
        v1 = 0x2f44(address(varg3), v0, varg1 << 96 & 0xffffffffffffffffffffffffffffffff000000000000000000000000);
        return bool(v1 % address(varg3)) + v1 / address(varg3);
    } else {
        v2 = 0x2f7e(address(varg3), v0, varg1 << 96 & 0xffffffffffffffffffffffffffffffff000000000000000000000000);
        assert(address(varg3));
        return v2 / address(varg3);
    }
}

function 0x2f44(uint256 varg0, uint256 varg1, uint256 varg2) private { 
    v0 = 0x2f7e(varg0, varg1, varg2);
    assert(varg0);
    if (varg2 * varg1 % varg0 <= 0) {
        return v0;
    } else {
        require(v0 < uint256.max);
        return 1 + v0;
    }
}

function 0x2f7e(uint256 varg0, uint256 varg1, uint256 varg2) private { 
    v0 = varg1 * varg2;
    v1 = varg2 * varg1 % uint256.max - v0 - (varg2 * varg1 % uint256.max < v0);
    if (v1) {
        require(varg0 > v1);
        v2 = varg2 * varg1 % varg0;
        v3 = varg0 & 0 - varg0;
        v4 = varg0 / v3;
        v5 = (2 - v4 * ((2 - v4 * ((2 - v4 * (0x2 ^ v4 * 3)) * (0x2 ^ v4 * 3))) * ((2 - v4 * (0x2 ^ v4 * 3)) * (0x2 ^ v4 * 3)))) * ((2 - v4 * ((2 - v4 * (0x2 ^ v4 * 3)) * (0x2 ^ v4 * 3))) * ((2 - v4 * (0x2 ^ v4 * 3)) * (0x2 ^ v4 * 3)));
        return ((v0 - v2) / v3 | (v1 - (v2 > v0)) * (1 + (0 - v3) / v3)) * ((2 - v4 * ((2 - v4 * ((2 - v4 * v5) * v5)) * ((2 - v4 * v5) * v5))) * ((2 - v4 * ((2 - v4 * v5) * v5)) * ((2 - v4 * v5) * v5)));
    } else {
        require(varg0 > 0);
        return v0 / varg0;
    }
}

function 0x302d(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3) private { 
    require(address(varg3) > 0);
    require(uint128(varg2) > 0);
    if (varg0) {
        v0 = 0x32f0(1, varg1, varg2, varg3);
        return v0;
    } else {
        v1 = 0x3220(1, varg1, varg2, varg3);
        return v1;
    }
}

function 0x308b(uint256 varg0) private { 
    v0 = v1 = 0;
    require(varg0 > v1);
    if (varg0 >= uint128.max + 1) {
        varg0 = v2 = varg0 >> 128;
        v0 = v3 = 128;
    }
    if (varg0 >= uint64.max + 1) {
        varg0 = v4 = varg0 >> 64;
        v0 = v5 = 64 + v0;
    }
    if (varg0 >= uint32.max + 1) {
        varg0 = v6 = varg0 >> 32;
        v0 = v7 = 32 + v0;
    }
    if (varg0 >= uint16.max + 1) {
        varg0 = v8 = varg0 >> 16;
        v0 = v9 = 16 + v0;
    }
    if (varg0 >= uint8.max + 1) {
        varg0 = v10 = varg0 >> 8;
        v0 = v11 = 8 + v0;
    }
    if (varg0 >= 16) {
        varg0 = v12 = varg0 >> 4;
        v0 = v13 = 4 + v0;
    }
    if (varg0 >= 4) {
        varg0 = v14 = varg0 >> 2;
        v0 = v15 = 2 + v0;
    }
    if (varg0 < 2) {
        return v0;
    } else {
        return 1 + v0;
    }
}

function 0x312b(uint256 varg0) private { 
    require(varg0 > 0);
    v0 = v1 = uint8.max;
    if (!uint128(varg0)) {
        varg0 = v2 = varg0 >> 128;
    } else {
        v0 = v3 = int8.max;
    }
    if (!uint64(varg0)) {
        varg0 = v4 = varg0 >> 64;
    } else {
        v0 = v5 = v0 - 64;
    }
    if (!uint32(varg0)) {
        varg0 = v6 = varg0 >> 32;
    } else {
        v0 = v7 = v0 - 32;
    }
    if (!uint16(varg0)) {
        varg0 = v8 = varg0 >> 16;
    } else {
        v0 = v9 = v0 - 16;
    }
    if (!uint8(varg0)) {
        varg0 = v10 = varg0 >> 8;
    } else {
        v0 = v11 = v0 - 8;
    }
    if (!bool(varg0)) {
        varg0 = v12 = varg0 >> 4;
    } else {
        v0 = v13 = v0 - 4;
    }
    if (!(varg0 & 0x3)) {
        varg0 = v14 = varg0 >> 2;
    } else {
        v0 = v15 = v0 - 2;
    }
    if (!(varg0 & 0x1)) {
        return v0;
    } else {
        return uint256.max + v0;
    }
}

function 0x3220(uint256 varg0, uint256 varg1, uint128 varg2, address varg3) private { 
    if (!varg0) {
        if (varg1 <= uint160.max) {
            v0 = bool((varg1 << 96) % varg2) + (varg1 << 96) / varg2;
        } else {
            v0 = v1 = 0x2f44(varg2, uint96.max + 1, varg1);
        }
        require(varg3 > v0);
        return varg3 - v0;
    } else {
        if (varg1 <= uint160.max) {
            assert(varg2);
            v2 = v3 = (varg1 << 96) / varg2;
        } else {
            v2 = v4 = 0x2f7e(varg2, uint96.max + 1, varg1);
        }
        return varg3 + v2;
    }
}

function 0x32f0(uint256 varg0, uint256 varg1, uint256 varg2, uint256 varg3) private { 
    if (varg1) {
        v0 = varg2 << 96 & 0xffffffffffffffffffffffffffffffff000000000000000000000000;
        if (!varg0) {
            v1 = address(varg3) * varg1;
            assert(varg1);
            v2 = v3 = v1 / varg1 == address(varg3);
            if (v3) {
                v2 = v4 = v0 > v1;
            }
            require(v2);
            v5 = 0x2f44(v0 - v1, address(varg3), v0);
            return v5;
        } else {
            assert(varg1);
            if (address(varg3) * varg1 / varg1 == address(varg3)) {
                if (address(varg3) * varg1 + v0 >= v0) {
                    v6 = 0x2f44(address(varg3) * varg1 + v0, address(varg3), v0);
                    return v6;
                }
            }
            assert(address(varg3));
            return bool(v0 % (v0 / address(varg3) + varg1)) + v0 / (v0 / address(varg3) + varg1);
        }
    } else {
        return varg3;
    }
}

function 0x3436() private { 
    v0 = new struct(9);
    v0.word0 = address(0x0);
    v0.word1 = int24(0);
    v0.word2 = int24(0);
    v0.word3 = False;
    v0.word4 = int16(0);
    v0.word5 = 0;
    v0.word6 = 0;
    v0.word7 = 0;
    v1 = new struct(6);
    v1.word0 = int24(0);
    v1.word1 = address(0x0);
    v1.word2 = uint128(0);
    v1.word3 = 0;
    v1.word4 = 0;
    v1.word5 = 0;
    v0.word8 = v1;
    return v0;
}

function receive() public payable {  find similar
}

function withdrawTo(address to, uint256 amount) public nonPayable {  find similar
    require(msg.data.length - 4 >= 64);
    require(0xf90029931c7a9a27e350cd35c91cbedbb58350c4 == msg.sender);
    v0 = to.call().value(amount).gas(2300 * !amount);
    require(bool(v0), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
}

// Note: The function selector is not present in the original solidity code.
// However, we display it for the sake of completeness.

function __function_selector__() private { 
    MEM[64] = 128;
    if (msg.data.length < 4) {
        if (!msg.data.length) {
            receive();
        }
    } else if (0x205c2878 == msg.data[0] >> 224) {
        withdrawTo(address,uint256);
    } else if (0x21f515c1 == msg.data[0] >> 224) {
        oneEyedMan();
    } else if (0x56eff5b7 == msg.data[0] >> 224) {
        0x56eff5b7();
    } else if (0x5b2e9917 == msg.data[0] >> 224) {
        withdrawERCTo(address,address,uint256);
    } else if (0x96ce0a56 == msg.data[0] >> 224) {
        0x96ce0a56();
    }
    v0 = v1 = 132;
    if (msg.data[4] == this) {
        v0 = v2 = 164;
    }
    v3 = msg.data[uint256.max + (v0 + msg.data[v0 - 32])] >> 248;
    if (v0 != 164) {
        v4 = v5 = msg.data[4];
        if (!(v5 >> uint8.max)) {
            v4 = v6 = msg.data[36];
        }
        v7 = v8 = 1 + ~v4;
    } else {
        v7 = v9 = msg.data[36];
        if (!v9) {
            v7 = v10 = msg.data[68];
        }
    }
    v11 = v0 + (msg.data[v0 - 32] - 17);
    v12 = v13 = v11 - 56;
    if (v3) {
        v12 = v14 = v0 + 28;
    }
    v15 = v16 = 1;
    if (v11 - v0 != 16) {
        if (164 == v0) {
            if (msg.data[v12] >> 248 < 2) {
                if (msg.data[v12] >> 248 != v3) {
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v17, v18 = address(msg.data[v12 + 2] >> 96).token1().gas(msg.gas);
                    require(bool(v17), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                    require(RETURNDATASIZE() >= 32);
                } else {
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v19, v18 = address(msg.data[v12 + 2] >> 96).token0().gas(msg.gas);
                    require(bool(v19), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                    require(RETURNDATASIZE() >= 32);
                }
                if (msg.data[v12 + 1] >> 248) {
                    require(bool((address(v18)).code.size));
                    v20, v7 = address(v18).balanceOf(this).gas(msg.gas);
                    require(bool(v20), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
                    require(RETURNDATASIZE() >= 32);
                }
                0x10b2(v7, msg.data[v12 + 2] >> 96, v18);
            }
        }
        while (v15) {
            v21 = this;
            if (!v3) {
                v15 = v22 = v12 - 28;
                if (v22 < v0) {
                    v15 = v23 = 0;
                }
            } else {
                v15 = v24 = 28 + v12;
                if (v24 >= v11) {
                    v15 = v25 = 0;
                }
            }
            if (v15) {
                if (msg.data[v15] >> 248 < 2) {
                    v21 = v26 = msg.data[v15 + 2] >> 96;
                }
            }
            if (msg.data[v12] >> 248 >= 2) {
                v27 = new bytes[](33);
                CALLDATACOPY(v27.data, msg.data.length, 33);
                if (msg.data[v12 + 1] >> 248) {
                    v28 = v29 = 0;
                    if ((msg.data[v12] >> 248) - 2 == v3) {
                        MEM[MEM[64]] = 0xdfe168100000000000000000000000000000000000000000000000000000000;
                        require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                        v30 = address(msg.data[v12 + 2] >> 96).staticcall(MEM[MEM[64]:MEM[64] + 4], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                        if (bool(v30)) {
                            require(RETURNDATASIZE() >= 32);
                            v31 = MEM[MEM[64]];
                        } else {
                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                            revert(0, RETURNDATASIZE());
                        }
                    } else {
                        MEM[MEM[64]] = 0xd21220a700000000000000000000000000000000000000000000000000000000;
                        require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                        v32 = address(msg.data[v12 + 2] >> 96).staticcall(MEM[MEM[64]:MEM[64] + 4], MEM[MEM[64]:MEM[64] + 32]).gas(msg.gas);
                        if (bool(v32)) {
                            require(RETURNDATASIZE() >= 32);
                            v31 = v33 = MEM[MEM[64]];
                        } else {
                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                            revert(0, RETURNDATASIZE());
                        }
                    }
                    MEM[MEM[64]] = 0x96ce0a5600000000000000000000000000000000000000000000000000000000;
                    MEM[MEM[64] + 4] = address(v31);
                    MEM[MEM[64] + 36] = address(msg.data[v12 + 2] >> 96);
                    require(bool(this.code.size));
                    v34 = v35 = this.call(MEM[MEM[64]:MEM[64] + 68], MEM[MEM[64]:MEM[64]]).gas(msg.gas);
                    if (v35) {
                        v34 = 1;
                    }
                    if (!v34) {
                        if (!RETURNDATASIZE()) {
                            v36 = v37 = 96;
                        } else {
                            v36 = v38 = MEM[64];
                            MEM[64] = v38 + (RETURNDATASIZE() + 63 & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                            MEM[v38] = RETURNDATASIZE();
                            RETURNDATACOPY(v38 + 32, 0, RETURNDATASIZE());
                        }
                        require(MEM[v36] >= 64);
                        v28 = MEM[32 + v36];
                        v7 = v39 = MEM[32 + v36 + 32];
                        require(v28);
                    }
                    MEM[v27.data] = v28 << 128;
                }
                if ((msg.data[v12] >> 248) - 2 == v3) {
                    MEM[MEM[64]] = 0x128acb0800000000000000000000000000000000000000000000000000000000;
                    MEM[4 + MEM[64]] = address(v21);
                    MEM[36 + MEM[64]] = True;
                    MEM[68 + MEM[64]] = v7;
                    MEM[100 + MEM[64]] = address(0x1000276a4);
                    MEM[132 + MEM[64]] = 160;
                    MEM[164 + MEM[64]] = v27.length;
                    v40 = v41 = 0;
                    while (v40 < v27.length) {
                        MEM[v40 + (196 + MEM[64])] = v27[v40];
                        v40 += 32;
                    }
                    v42 = v43 = v27.length + (196 + MEM[64]);
                    if (1) {
                        MEM[v43 - 1] = bytes1(MEM[v43 - 1]);
                        v42 = 32 + (v43 - 1);
                    }
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v44 = address(msg.data[v12 + 2] >> 96).call(MEM[MEM[64]:MEM[64] + vb09V0xb6 - MEM[64]], MEM[MEM[64]:MEM[64] + 64]).gas(msg.gas);
                    if (bool(v44)) {
                        require(RETURNDATASIZE() >= 64);
                        v7 = v45 = 0 - MEM[32 + MEM[64]];
                    } else {
                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                        revert(0, RETURNDATASIZE());
                    }
                } else {
                    MEM[MEM[64]] = 0x128acb0800000000000000000000000000000000000000000000000000000000;
                    MEM[4 + MEM[64]] = address(v21);
                    MEM[36 + MEM[64]] = False;
                    MEM[68 + MEM[64]] = v7;
                    MEM[100 + MEM[64]] = address(0xfffd8963efd1fc6a506488495d951d5263988d25);
                    MEM[132 + MEM[64]] = 160;
                    MEM[164 + MEM[64]] = v27.length;
                    v46 = v47 = 0;
                    while (v46 < v27.length) {
                        MEM[v46 + (196 + MEM[64])] = v27[v46];
                        v46 += 32;
                    }
                    v48 = v49 = v27.length + (196 + MEM[64]);
                    if (1) {
                        MEM[v49 - 1] = bytes1(MEM[v49 - 1]);
                        v48 = 32 + (v49 - 1);
                    }
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v50 = address(msg.data[v12 + 2] >> 96).call(MEM[MEM[64]:MEM[64] + v9eeV0xb6 - MEM[64]], MEM[MEM[64]:MEM[64] + 64]).gas(msg.gas);
                    if (bool(v50)) {
                        require(RETURNDATASIZE() >= 64);
                        v7 = v51 = 0 - MEM[MEM[64]];
                    } else {
                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                        revert(0, RETURNDATASIZE());
                    }
                }
            } else {
                if (!(msg.data[v12 + 1] >> 248)) {
                    v7 = 0x1282(msg.data[v12 + 2] >> 96, v7, msg.data[v12] >> 248 == v3);
                } else {
                    if (msg.data[v12] >> 248 == v3) {
                        v52 = v53 = 1564;
                        v54 = v55 = 1;
                        v56 = v57 = address(msg.data[v12 + 2] >> 96);
                        MEM[MEM[64]] = 0xdfe168100000000000000000000000000000000000000000000000000000000;
                        v58 = v59 = 32;
                        v60 = v61 = MEM[64];
                        v62 = v63 = 4;
                        require(bool(v57.code.size));
                    } else {
                        v52 = v64 = 1495;
                        v54 = v65 = 0;
                        v56 = v66 = address(msg.data[v12 + 2] >> 96);
                        MEM[MEM[64]] = 0xd21220a700000000000000000000000000000000000000000000000000000000;
                        v58 = v67 = 32;
                        v60 = v68 = MEM[64];
                        v62 = v69 = 4;
                        require(bool(v66.code.size));
                    }
                    v70 = v56.staticcall(MEM[v52f_0x4V0xb6:v52f_0x4V0xb6 + v52f_0x3V0xb6], MEM[v52f_0x4V0xb6:v52f_0x4V0xb6 + v52f_0x5V0xb6]).gas(msg.gas);
                    if (bool(v70)) {
                        require(RETURNDATASIZE() >= 32);
                        MEM[MEM[64]] = 0x70a0823100000000000000000000000000000000000000000000000000000000;
                        require(bool((address(MEM[MEM[0x40]])).code.size));
                        v71 = address(MEM[MEM[0x40]]).staticcall(v72, address(msg.data[v12 + 2] >> 96)).gas(msg.gas);
                        if (bool(v71)) {
                            require(RETURNDATASIZE() >= 32);
                            MEM[MEM[64]] = 0x902f1ac00000000000000000000000000000000000000000000000000000000;
                            require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                            v73 = address(msg.data[v12 + 2] >> 96).staticcall(MEM[MEM[64]:MEM[64] + 4], MEM[MEM[64]:MEM[64] + 96]).gas(msg.gas);
                            if (bool(v73)) {
                                require(RETURNDATASIZE() >= 96);
                                v74 = v75 = uint112(MEM[MEM[64]]);
                                v74 = v76 = uint112(MEM[MEM[64] + 32]);
                                assert(1000 * v74 + 997 * (MEM[MEM[64]] - v74));
                                v7 = 997 * (MEM[MEM[64]] - v74) * v74 / (1000 * v74 + 997 * (MEM[MEM[64]] - v74));
                                // Unknown jump to Block {'0x5d7B0xb6', '0x61cB0xb6'}. Refer to 3-address code (TAC);
                            } else {
                                RETURNDATACOPY(0, 0, RETURNDATASIZE());
                                revert(0, RETURNDATASIZE());
                            }
                        } else {
                            RETURNDATACOPY(0, 0, RETURNDATASIZE());
                            revert(0, RETURNDATASIZE());
                        }
                    } else {
                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                        revert(0, RETURNDATASIZE());
                    }
                }
                if (msg.data[v12] >> 248 == v3) {
                    MEM[MEM[64]] = 0x22c0d9f00000000000000000000000000000000000000000000000000000000;
                    v77 = new uint256[](0);
                    v78 = v77.data;
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v79 = address(msg.data[v12 + 2] >> 96).call(v72, 0, v7, address(v21), v77).gas(msg.gas);
                    if (!bool(v79)) {
                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                        revert(0, RETURNDATASIZE());
                    }
                } else {
                    MEM[MEM[64]] = 0x22c0d9f00000000000000000000000000000000000000000000000000000000;
                    v80 = new uint256[](0);
                    v81 = v80.data;
                    require(bool((address(msg.data[v12 + 2] >> 96)).code.size));
                    v82 = address(msg.data[v12 + 2] >> 96).call(v72, v7, 0, address(v21), v80).gas(msg.gas);
                    if (!bool(v82)) {
                        RETURNDATACOPY(0, 0, RETURNDATASIZE());
                        revert(0, RETURNDATASIZE());
                    }
                }
            }
            if (!v3) {
                v12 = v12 - 28;
            } else {
                v12 = v12 + 28;
            }
        }
        if (!v3) {
            v83 = v84 = v11 - 26;
        } else {
            v83 = 2 + v0;
        }
        0x10b2(msg.data[v11] >> 128, msg.data[v83] >> 96, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2);
    } else {
        v85 = v86 = 0;
        v87 = v88 = msg.data[4];
        if (v88 >> uint8.max) {
            v85 = 1;
            v87 = msg.data[36];
        }
        v87 = v89 = msg.data[v0] >> 128;
        if (!v85) {
            require(bool(msg.sender.code.size));
            v90, /* uint256 */ v91 = msg.sender.token0().gas(msg.gas);
            require(bool(v90), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
            require(RETURNDATASIZE() >= 32);
        } else {
            require(bool(msg.sender.code.size));
            v92, /* uint256 */ v91 = msg.sender.token1().gas(msg.gas);
            require(bool(v92), 0, RETURNDATASIZE()); // checks call status, propagates error data on error
            require(RETURNDATASIZE() >= 32);
        }
        0x10b2(v87, msg.sender, v91);
    }
}
