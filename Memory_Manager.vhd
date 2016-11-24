library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.const.ALL;

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
		data_ready, tbre, tsre: in std_logic;
		
		flash_byte : out std_logic;
		flash_vpen : out std_logic;
		flash_ce   : out std_logic;
		flash_oe   : out std_logic;
		flash_we   : out std_logic;
		flash_rp   : out std_logic;
		flash_addr : buffer std_logic_vector(22 downto 1);
		flash_data : inout std_logic_vector(15 downto 0)
	);
end Memory_Manager;

architecture Behavioral of Memory_manager is
	component sram is
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
	end component;
	
	component uart is
		port(
			clk_0, rst: in std_logic;
			
			status: in std_logic_vector(3 downto 0);
			din_uart: in std_logic_vector(15 downto 0);
			dout_uart: out std_logic_vector(15 downto 0);
			sta_uart: out std_logic_vector(1 downto 0);
			
			ram1_data: inout std_logic_vector(15 downto 0);
			rdn, wrn: out std_logic;
			data_ready, tbre, tsre: in std_logic
		);
	end component;
	
	component flash is 
		port(
			clk_0, rst: in std_logic;
			status : in std_logic_vector(3 downto 0);
			flash_byte : out std_logic;
			flash_vpen : out std_logic;
			flash_ce   : out std_logic;
			flash_oe   : out std_logic;
			flash_we   : out std_logic;
			flash_rp   : out std_logic;
			flash_addr : buffer std_logic_vector(22 downto 1);
			flash_data : inout std_logic_vector(15 downto 0);
			dout_flash : out std_logic_vector(15 downto 0)
		);
	end component;
			
	
	signal read_pc, rst_ram: std_logic;
	signal ramtype :std_logic_vector(1 downto 0);
	signal status : std_logic_vector(3 downto 0);
	signal dout_ram, dout_uart, dout_flash : std_logic_vector(15 downto 0);
	signal sta_uart : std_logic_vector(1 downto 0);
	
begin
	ram1_en <= '1';
	ram1_oe <= '1';
	ram1_we <= '1';
	ram1_address <= (others => '1');
	ram2_en <= '0';
	
	u1: sram port map(
		clk_0 => clk_0,
		rst => rst_ram,
		pc_ram => pc_IF,
		read_pc => read_pc,
		ins_ram => ins_IF,
		
		status => status,
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
		sta_uart => sta_uart,
		
		ram1_data => ram1_data,
		rdn => rdn,
		wrn => wrn,
		data_ready => data_ready,
		tbre => tbre,
		tsre => tsre
	);
	
	u3 : flash port map(
		clk_0 => clk_0,
		rst => rst,
		status => status,
		flash_byte => flash_byte,
		flash_vpen => flash_vpen,
		flash_ce => flash_ce,
		flash_oe => flash_oe,
		flash_we => flash_we,
		flash_rp => flash_rp,
		flash_addr => flash_addr,
		flash_data => flash_data,
		dout_flash => dout_flash
	);
	
	ramtype <= UART_PORT when addr_MEM = x"BF00"
			else UART_TEST when addr_MEM = x"BF01"
			else FLASH_PORT when addr_MEM = x"BF02"
			else RAM_PORT;
	status <= ramtype & oe_MEM & we_MEM;
	
	dout_MEM <= dout_ram when status = read_ram
			 else dout_uart when status = read_uart
			 else ZERO14 & sta_uart when status = test_uart
			 else x"0101" when status = read_flash
			 else (others => '1');
			 
	process(clk)
	begin
		if(clk'event and clk = '1')then
			rst_ram <= rst;
			if(rst = '0')then
				read_pc <= '1';
			elsif(read_pc = '0')then
				read_pc <= '1';
			else
				if((status = read_ram or status = write_ram))then
					read_pc <= '0';
				end if;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if(clk'event and clk = '0') then
			if(read_pc = '1' and (status = read_ram or status = write_ram)) then
				stop <= '1';
			else 
				stop <= '0';
			end if;
		end if;
	end process;
			
end Behavioral;
