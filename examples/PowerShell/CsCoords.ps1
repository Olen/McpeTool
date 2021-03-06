$source = @"
using System;

public class McBedrockTool {
    public static string GetKeyByCoords(int x, int z, int y = 0, int Dimension = 0, byte Tag = 0x2f) {
        int ChunkX = x / 16;
        int ChunkZ = z / 16;
        byte SubChunkY = (byte) (y / 16);
        string MyKey = HexKey(ChunkX) +
            HexKey(ChunkZ) +
            (Dimension == 0 ? "" : HexKey(Dimension)) +
            HexKey(Tag) +
            (Tag == 0x2f ? HexKey(SubChunkY) : "");
        return MyKey;
    }
    public static string HexKey(int i) {
        byte[] ByteArray = BitConverter.GetBytes(i);
        // Force byte order to little endian no matter the local platform
        if (! BitConverter.IsLittleEndian)
            Array.Reverse(ByteArray);
        return String.Concat(Array.ConvertAll(ByteArray, x => x.ToString("X2")));
    }
    public static string HexKey(byte i) {
        return i.ToString("X2");
    }
}
"@

Add-Type -TypeDefinition $source

"Overworld subchunk coordinate"
[McBedrockTool]::GetKeyByCoords(413,54,90)
# 19000000030000002F05

"Negative example"
[McBedrockTool]::GetKeyByCoords(-413,54,90)
# E7FFFFFF030000002F05

"Nether dimension"
[McBedrockTool]::GetKeyByCoords(-413,54,90, -1)
# E7FFFFFF03000000FFFFFFFF2F05

"End dimension"
[McBedrockTool]::GetKeyByCoords(413,-54,90, 1)
# E7FFFFFF03000000010000002F05

"Overworld block entity data key"
# Y is irrelevant here and Dimension redundant, but I can't use named parameters from PowerShell to C#
[McBedrockTool]::GetKeyByCoords(413,54,90, 0, 50)
# 190000000300000032
