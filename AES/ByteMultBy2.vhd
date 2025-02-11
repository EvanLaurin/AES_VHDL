----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ByteMultBy2 is
    Port ( Byte 	: in  STD_LOGIC_VECTOR (7 downto 0);
           Result : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end ByteMultBy2;

architecture Structural of ByteMultBy2 is

signal opxor : STD_LOGIC_VECTOR (8 downto 0);

begin
	opxor <= Byte & "0";
   result <= opxor(7 downto 0) xor  "000" & opxor(8) & opxor(8) &  "0" & opxor(8) & opxor(8);
end Structural;

