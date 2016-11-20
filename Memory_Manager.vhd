library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use const.ALL;

entity Memory_Manager is
	port(
		clk_0, clk, rst: in std_logic;
		pc_IF: in std_logic_vector(15 downto 0);
		ins_IF: out std_logic_vector(15 downto 0);
		stop: out std_logic;
		
		oe_MEM, we_MEM: in std_logic;
		addr_MEM: in std_logic_vector(15 downto 0);
		din_MEM: in std_logic_vector(15 downto 0);
		dout_MEM: out std_logic_vector(15 downto 0);
		
		ram1_oe, ram1_we, ram1_en : out std_logic;
		ram1_address: out std_logic_vector(17 downto 0);
		ram1_data: inout std_logic_vector(15 downto 0);
		
		ram2_oe, ram2_we, ram2_en : out std_logic;
		ram2_address: out std_logic_vector(17 downto 0);
		ram2_data: inout std_logic_vector(15 downto 0);
		
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end Memory_Manager;

architecture Behavioral of Memory_manager is
	component sram is
		port(
			clk_0, rst: in std_logic;
			status: in std_logic_vector(2 downto 0);
			pc_ram: in std_logic_vector(15 downto 0);
			addr_ram: in std_logic_vector(15 downto 0);
			din_ram: in std_logic_vector(15 downto 0);
			dout_ram: out std_logic_vector(15 downto 0);
			
			ram2_oe, ram2_we: out std_logic;
			ram2_address: out std_logic_vector(17 downto 0);
			ram2_data: inout std_logic_vector(15 downto 0)
		);
	end component;
	
	component uart is
		port(
			clk_0, rst: in std_logic;
			status: in std_logic_vector(2 downto 0);
			din_uart: in std_logic_vector(15 downto 0);
			dout_uart: out std_logic_vector(15 downto 0);
			uart_finish: out std_logic_vector(1 downto 0);
			
			ram1_data: inout std_logic_vector(15 downto 0);
			rdn, wrn: out std_logic;
			data_ready, tbre, tsre: in std_logic
		);
	end component;
	
	signal status : std_logic_vector(2 downto 0);
	signal dout_ram, dout_uart : std_logic_vector(15 downto 0);
	signal p0, p1: std_logic;
	signal uart_finish: std_logic_vector(1 downto 0);
	
begin
	ram1_en <= '1';
	ram1_oe <= '1';
	ram1_we <= '1';
	ram1_address <= (others => '1');
	ram2_en <= '0';
	
	u1: sram port map(
		clk_0 => clk_0,
		rst => rst,
		status => status,
		pc_ram => pc_IF,
		addr_ram => addr_MEM,
		din_ram => din_MEM,
		dout_ram => dout_ram,
		
		ram2_oe => ram2_oe,
		ram2_we => ram2_we,
		ram2_address => ram2_address,
		ram2_data => ram2_data
	);
	
	u2 : uart port map(
		clk_0 => clk_0,
		rst => rst,
		status => status,
		din_uart => din_MEM,
		dout_uart => dout_uart,
		uart_finish => uart_finish,
		
		ram1_data => ram1_data,
		rdn => rdn,
		wrn => wrn,
		data_ready => data_ready,
		tbre => tbre,
		tsre => tsre
	);
	
	p0<= '1' when addr_MEM = x"BF00" else '0';
	p1<= '1' when addr_MEM = x"BF01" else '0';
	
	process(clk)
		variable tmp : std_logic_vector(3 downto 0);
	begin
		if(clk'event and clk = '1')then
			if(rst = '0')then
				status <= read_pc;
			else
				case status is
					when read_pc =>
						ins_IF <= dout_ram;
						tmp := oe_MEM & we_MEM & p0 & p1;
						case tmp is
							when "0000" =>
								status <= read_pc;
							when "1000" =>
								status <= read_ram;
							when "0100" =>
								status <= write_ram;
							when "1010" =>
								status <= read_uart;
							when "0110" =>
								status <= write_uart;
							when "0101" =>
								status <= test_uart;
							when others =>
								status <= wrong_type;
						end case;
					when others =>
						status <= read_pc;
				end case;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if(clk'event and clk = '0') then
			if((oe_MEM = '1' or we_MEM = '1') and status = read_pc) then
				stop <= '1';
			else 
				stop <= '0';
			end if;
		end if;
	end process;
	
	dout_MEM <= dout_ram when status = read_ram
			 else dout_uart when status = read_uart
			 else ZERO14 & uart_finish when status = test_uart
			 else (others => '1');
			
end Behavioral;
