----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyScheduler is
	port (clk			: in 	std_logic;
			reset			: in 	std_logic;
			counter		: in 	std_logic_vector(7 downto 0);
			key			: in 	std_logic_vector(127 downto 0);
			key_out	 	: out std_logic_vector(127 downto 0)
			);
end KeyScheduler;

architecture Behavioral of KeyScheduler is

component RotateLeft
	port (byte_in  : in std_logic_vector(31 downto 0);
			byte_out  : out std_logic_vector(31 downto 0)
			);   
end component;

component RCon
	port (clk	: in std_logic;
			reset	: in std_logic;
			inc 	: in std_logic;
			r_con	: out std_logic_vector(7 downto 0)
			);
end component;

component SubBytes
    Port ( 
        byte_in  : in std_logic_vector(7 downto 0);
        byte_out  : out std_logic_vector(7 downto 0));
end component;

signal w0, w1, w2, w3 : std_logic_vector(31 downto 0);
signal round_const	 : std_logic_vector(7 downto 0);
signal inc_signal 	 : std_logic;

signal round_key :	std_logic_vector(127 downto 0);

signal step	: std_logic_vector(3 downto 0);
signal round: std_logic_vector(3 downto 0);

signal rot_out : std_logic_vector(31 downto 0);
signal rot_in  : std_logic_vector(31 downto 0);
signal sub_out : std_logic_vector(31 downto 0);
signal sub_in  : std_logic_vector(31 downto 0);


begin

rotate_left : RotateLeft
	port map (
		byte_in  => rot_in,
      byte_out => rot_out
   );

sub_bytes_0: SubBytes
    port map ( 
        byte_in  => sub_in(31 downto 24),
        byte_out => sub_out(31 downto 24)
	);
sub_bytes_1: SubBytes
    port map ( 
        byte_in  => sub_in(23 downto 16),
        byte_out => sub_out(23 downto 16)
	);
sub_bytes_2: SubBytes
    port map ( 
        byte_in  => sub_in(15 downto 8),
        byte_out => sub_out(15 downto 8)
	);
sub_bytes_3: SubBytes
    port map ( 
        byte_in  => sub_in(7 downto 0),
        byte_out => sub_out(7 downto 0)
	);

sub_in <= rot_out;

r_con : RCon
	port map (
		clk   => clk,
		reset => reset,
		inc   => inc_signal,
		r_con => round_const
  );
  
  
step 	<=	counter(3 downto 0); 
round <=	counter(7 downto 4); 

key_gen : process(clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			inc_signal <= '0';
			round_key <= key;
			w0 <=	round_key(31  downto 0 );
			w1 <=	round_key(63  downto 32);
			w2 <=	round_key(95  downto 64);
			w3 <=	round_key(127 downto 96);
		else
			case step is
				when "0000" => 
					rot_in <= w0; 
					inc_signal <= '0';
					w0 <= sub_out xor round_const & x"000000";
				when "0001" =>
					rot_in <= w1; 
					w1 <= sub_out xor round_const & x"000000";
				when "0010" =>
					rot_in <= w2; 
					w2 <= sub_out xor round_const & x"000000";
				when "0011" =>
					rot_in <= w3; 
					w3 <= sub_out xor round_const & x"000000";
				when "1111" =>
					round_key <= w3 & w2 & w1 & w0;
					inc_signal <= '1';
				when others =>
					null;
			end case;
		end if;
	end if;
end process key_gen;

key_out <= round_key;

end Behavioral;

