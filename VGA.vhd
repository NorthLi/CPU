----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:59:42 11/25/2016 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
	port(
			address		:		  out	STD_LOGIC_VECTOR(14 DOWNTO 0);
			address_rom	:		out std_logic_vector(9 downto 0);
			reset       :         in  STD_LOGIC;
			data		:			in std_logic_vector(15 downto 0);
			q		    :		  in STD_LOGIC_vector(15 downto 0);
			clk       	:         in  STD_LOGIC;
			hs,vs       :         out STD_LOGIC;
			r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	);
end VGA;

architecture Behavioral of VGA is

	signal r1, g1, b1 : STD_LOGIC_vector(2 downto 0);
	signal hs1, vs1 : STD_LOGIC;
	signal vector_x, temp_x : std_logic_vector(9 downto 0);
	signal vector_y, temp_y : std_logic_vector(8 downto 0);

begin

	process(clk,reset)
	 begin
	  	if reset='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;
	 
	 process(clk,reset)
	 begin
	  	if reset='0' then
	   		vector_y <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
	 
	 process(clk,reset)
	 begin
		  if reset='0' then
		   hs1 <= '1';
		  elsif clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
	 
	 process(clk,reset)
	 begin
	  	if reset='0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
	 
	 process(clk,reset)
	 begin
	  	if reset='0' then
	   		hs <= '0';
	  	elsif clk'event and clk='1' then
	   		hs <=  hs1;
	  	end if;
	 end process;
	 
	 process(clk,reset)
	 begin
	  	if reset='0' then
	   		vs <= '0';
	  	elsif clk'event and clk='1' then
	   		vs <=  vs1;
	  	end if;
	 end process;
	 
	 process(reset, clk, vector_x, vector_y, q)
	 begin
		if reset = '0' then 
			r1 <= "000";
			g1 <= "000";
			b1 <= "000";
		elsif(clk'event and clk = '1') then 
			if vector_x < 512 and vector_x >= 0 and vector_y < 480 and vector_y >= 0 then
				address <= "0000" & vector_y(8 downto 4) & vector_x(8 downto 3);
				address_rom <= data(6 downto 0) &  vector_y(3 downto 1);
				if vector_y(0) = '1' then
					case vector_x(2 downto 0) is
						when "010" => 
							r1 <= (others => q(7));
							g1 <= (others => q(7));
							b1 <= (others => q(7));
						when "011" => 
							r1 <= (others => q(6));
							g1 <= (others => q(6));
							b1 <= (others => q(6));
						when "100" => 
							r1 <= (others => q(5));
							g1 <= (others => q(5));
							b1 <= (others => q(5));
						when "101" => 
							r1 <= (others => q(4));
							g1 <= (others => q(4));
							b1 <= (others => q(4));
						when "110" => 
							r1 <= (others => q(3));
							g1 <= (others => q(3));
							b1 <= (others => q(3));
						when "111" => 
							r1 <= (others => q(2));
							g1 <= (others => q(2));
							b1 <= (others => q(2));
						when "000" => 
							r1 <= (others => q(1));
							g1 <= (others => q(1));
							b1 <= (others => q(1));
						when "001" => 
							r1 <= (others => q(0));
							g1 <= (others => q(0));
							b1 <= (others => q(0));
						when others =>
							r1 <= (others => q(7));
							g1 <= (others => q(7));
							b1 <= (others => q(7));
					end case;
				else
					case vector_x(2 downto 0) is
						when "010" => 
							r1 <= (others => q(15));
							g1 <= (others => q(15));
							b1 <= (others => q(15));
						when "011" => 
							r1 <= (others => q(14));
							g1 <= (others => q(14));
							b1 <= (others => q(14));
						when "100" => 
							r1 <= (others => q(13));
							g1 <= (others => q(13));
							b1 <= (others => q(13));
						when "101" => 
							r1 <= (others => q(12));
							g1 <= (others => q(12));
							b1 <= (others => q(12));
						when "110" => 
							r1 <= (others => q(11));
							g1 <= (others => q(11));
							b1 <= (others => q(11));
						when "111" => 
							r1 <= (others => q(10));
							g1 <= (others => q(10));
							b1 <= (others => q(10));
						when "000" => 
							r1 <= (others => q(9));
							g1 <= (others => q(9));
							b1 <= (others => q(9));
						when "001" => 
							r1 <= (others => q(8));
							g1 <= (others => q(8));
							b1 <= (others => q(8));
						when others =>
							r1 <= (others => q(7));
							g1 <= (others => q(7));
							b1 <= (others => q(7));
					end case;
				end if;
			else
				r1 <= "000";
				g1 <= "000";
				b1 <= "000";
			end if;
		end if;
	end process;
	
	process (hs1, vs1, r1, g1, b1)
	begin
		if hs1 = '1' and vs1 = '1' then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;
			


end Behavioral;

