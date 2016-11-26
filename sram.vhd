library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.ALL;

entity sram is
	port(
		clk_0, rst: in std_logic;
		read_pc: in std_logic;
		pc_ram: in std_logic_vector(15 downto 0);
		ins_ram: out std_logic_vector(15 downto 0);
		
		status: in std_logic_vector(3 downto 0);
		addr_ram: in std_logic_vector(15 downto 0);
		din_ram: in std_logic_vector(15 downto 0);
		dout_ram: out std_logic_vector(15 downto 0);
		
		ram2_oe, ram2_we: out std_logic;
		ram2_address: out std_logic_vector(17 downto 0);
		ram2_data: inout std_logic_vector(15 downto 0)
	);
end sram;

architecture Behavioral of sram is
	signal fist_period : std_logic;
	signal output_ins : std_logic_vector(15 downto 0);
	
	component rom is
		port(
			input_addr : in std_logic_vector(15 downto 0);
			output_ins : out std_logic_vector(15 downto 0)
		);
	end component;
	
begin
	u1: rom port map(
		input_addr => pc_ram,
		output_ins => output_ins
	);
	
	ram2_address(17 downto 16) <= "00";
	ram2_data <= din_ram when status = write_ram else (others => 'Z');
	dout_ram <= ram2_data;
	
	process(clk_0)
	begin
		if(clk_0'event and clk_0 = '0')then
			if(rst = '0') then
				fist_period <= '0';
				ins_ram <= x"0800";
			elsif(fist_period = '0')then
				fist_period <= '1';
				if(read_pc = '1')then
					ram2_we <= '1';
					ram2_oe <= '0';
					ram2_address(15 downto 0) <=pc_ram;
				else
					case status is
						when read_ram =>
							ram2_we <= '1';
							ram2_oe <= '0';
							ram2_address(15 downto 0) <= addr_ram;
						when write_ram =>
							ram2_oe <= '1';
							ram2_we <= '0';
							ram2_address(15 downto 0) <= addr_ram;
						when others =>
							ram2_oe <= '1';
							ram2_we <= '1';
					end case;
				end if;
			else
				fist_period <= '0';
				ram2_oe <= '1';
				ram2_we <= '1';
				if(read_pc = '1')then
					if(pc_ram < x"0011")then
						ins_ram <= output_ins;
					else
						ins_ram <= ram2_data;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;
