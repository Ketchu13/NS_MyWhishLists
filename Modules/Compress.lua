-- Author      : ketch
-- Create Date : 12/5/2020 2:48:40 PM


local addonname, NSCom = ...
local _G = getfenv(0)
local NS_MyWishList =_G.NS_MyWishList

NS_MyWishList.libDeflate = LibStub:GetLibrary("LibDeflate");

function NS_MyWishList:Compress(input_)
    -- Compress using raw deflate format
    local compress_deflate = NS_MyWishList.libDeflate:CompressDeflate(input_)
    return compress_deflate
end
function NS_MyWishList:Decompress(compress_deflate)
    -- Compress using raw deflate format
    local decompress_deflate = NS_MyWishList.libDeflate:DecompressDeflate(compress_deflate)
    return decompress_deflate
end
function NS_MyWishList:PrintCompressed(compress_deflate)
    -- Compress using raw deflate format
    local printable_compressed = NS_MyWishList.libDeflate:EncodeForPrint(compress_deflate)
    return printable_compressed
end
function NS_MyWishList:RecompressPrintable(printable_compressed)
    -- Compress using raw deflate format
    local compress_deflate = NS_MyWishList.libDeflate:DecodeForPrint(printable_compressed)
    return compress_deflate
end
