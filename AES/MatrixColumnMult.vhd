----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MatrixColumnMult is
	port( col_in  : in std_logic_vector(31 downto 0);
			col_out  : out std_logic_vector(31 downto 0)
			);
end MatrixColumnMult;

architecture Structural of MatrixColumnMult is

component ByteMultBy2
    Port ( Byte 	: in  STD_LOGIC_VECTOR (7 downto 0);
           Result : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end component;

signal m0, m1, m2, m3 : STD_LOGIC_VECTOR (7 downto 0);
signal s0, s1, s2, s3 : STD_LOGIC_VECTOR (7 downto 0);

begin
	bmb20 : ByteMultBy2
		port map(col_in(31 downto 24), m0);
	bmb21 : ByteMultBy2
		port map(col_in(23 downto 16), m1);
	bmb22 : ByteMultBy2
		port map(col_in(15 downto 8),  m2);
	bmb23 : ByteMultBy2
		port map(col_in(7 downto 0),   m3);

	s0 <= m0										xor m1 xor col_in(23 downto 16)	xor col_in(15 downto 8) 			xor col_in(7 downto 0);
	s1 <= col_in(31 downto 24) 			xor m1						 			xor m2 xor col_in(15 downto 8) 	xor col_in(7 downto 0);
	s2 <= col_in(31 downto 24) 			xor col_in(23 downto 16) 			xor m2 					 				xor m3 xor col_in(7 downto 0);
	s3 <= m0 xor col_in(31 downto 24)	xor col_in(23 downto 16) 			xor col_in(15 downto 8) 			xor m3;

	col_out <= s0 & s1 & s2 & s3;

end Structural;
