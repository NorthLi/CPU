library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Thinpad is
	port(
		clk_0: in std_logic;
		rst : in std_logic;
		
		ram1_oe, ram1_we, ram1_en : out std_logic;
		ram1_address: out std_logic_vector(17 downto 0);
		ram1_data: inout std_logic_vector(15 downto 0);
		
		rdn, wrn: out std_logic;
		data_ready, tbre, tsre: in std_logic
	);
end Thinpad;

architecture Behavioral of Thinpad is

	component IF_ID is
		port(
			clk, rst: in std_logic;
			stop, bubble: in std_logic;
			int: in std_logic;
			
			pc_IF: in std_logic_vector(15 downto 0);
			ins_IF: in std_logic_vector(15 downto 0);
			
			pc_ID: out std_logic_vector(15 downto 0);
			ins_ID: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component ID_EX is
		port(
			clk, rst: in std_logic;
			stop, bubble: in std_logic;
			int: in std_logic;
			
			op_ID: in std_logic_vector(3 downto 0);
			datax_ID, datay_ID, dataz_ID: in std_logic_vector(15 downto 0);
			rx_ID, ry_ID, rz_ID: in std_logic_vector(3 downto 0);
			we_ID, oe_ID: in std_logic;
			
			op_EX: out std_logic_vector(3 downto 0);
			datax_EX, datay_EX, dataz_EX: out std_logic_vector(15 downto 0);
			rx_EX, ry_EX, rz_EX: in std_logic_vector(3 downto 0);	
			we_EX, oe_EX: out std_logic
		);
	end component;	
		
	component EX_MEM is
		port(
			clk, rst: in std_logic;
			stop, bubble: in std_logic;
			
			rz_EX: in std_logic_vector(3 downto 0);
			we_EX, oe_EX: in std_logic;
			addr_EX: in std_logic_vector(15 downto 0);
			din_EX: in std_logic_vector(15 downto 0);
			
			rz_MEM: out std_logic_vector(3 downto 0);
			we_MEM, oe_MEM: out std_logic;
			addr_MEM: out std_logic_vector(15 downto 0);
			din_MEM: out std_logic_vector(15 downto 0)		
		);
	end component;
	
	component MEM_WB is
		port(
			clk, rst:in std_logic;
			stop: in std_logic;
			
			rz_MEM: in std_logic_vector(3 downto 0);
			dataz_MEM: in std_logic_vector(15 downto 0);
			
			rz_WB: out std_logic_vector(3 downto 0);
			dataz_WB: out std_logic_vector(15 downto 0)	
		);
	end component;
	
	component PC_Choose is
		port(
			clk, rst: in std_logic;
			stop, bubble:in std_logic;
			int: in std_logic;
		
			pc_branch: in std_logic_vector(15 downto 0);
			pc_ctrl: in std_logic;
			
			pc_IF: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Identify is
		port(
			ins_ID: in std_logic_vector(15 downto 0);
			pc_ID: in std_logic_vector(15 downto 0);
			
			rz_EX, rz_MEM: in std_logic_vector(3 downto 0);
			dataz_EX, dataz_MEM: in std_logic_vector(15 downto 0);
			
			rx_reg, ry_reg: out std_logic_vector(3 downto 0);
			datax_reg, datay_reg: in std_logic_vector(15 downto 0);
			
			pc_ctrl:out std_logic;
			pc_branch: out std_logic_vector(15 downto 0);
			
			op_ID: out std_logic_vector(3 downto 0);
			we_ID, oe_ID: out std_logic;
			rx_ID, ry_ID, rz_ID: out std_logic_vector(3 downto 0);
			datax_ID, datay_ID, dataz_ID: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Register_Heap is
		port(
			clk, rst: in std_logic;
					
			rx_reg, ry_reg: in std_logic_vector(3 downto 0);
			datax_reg, datay_reg: out std_logic_vector(15 downto 0);
		
			rz_WB: in std_logic_vector(3 downto 0);
			dataz_WB: in std_logic_vector(15 downto 0)
		);
	end component;
	
	component ALU is
		port(
			op_EX: in std_logic_vector(3 downto 0);
			datax_EX, datay_EX: in std_logic_vector(15 downto 0);
			dataz_ALU: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Memory_Manager is
		port(
			clk, rst: in std_logic;
			pc_IF: in std_logic_vector(15 downto 0);
			ins_IF: out std_logic_vector(15 downto 0);
			
			oe_MEM, we_MEM: in std_logic;
			addr_MEM: in std_logic_vector(15 downto 0);
			din_MEM: in std_logic_vector(15 downto 0);
			dout_MEM: out std_logic_vector(15 downto 0);
			
			ram1_oe, ram1_we, ram1_en : out std_logic;
			ram1_address: out std_logic_vector(17 downto 0);
			ram1_data: inout std_logic_vector(15 downto 0);
			
			rdn, wrn: out std_logic;
			data_ready, tbre, tsre: in std_logic
		);
	end component;
	
	-- Control Signal
	signal clk, stop, bubble, int: std_logic;
	
	-- IF_ID
	signal pc_IF: std_logic_vector(15 downto 0);
	signal ins_IF: std_logic_vector(15 downto 0);
	
	signal pc_ID: std_logic_vector(15 downto 0);
	signal ins_ID: std_logic_vector(15 downto 0);
	
	-- ID_EX
	signal op_ID: std_logic_vector(3 downto 0);
	signal datax_ID, datay_ID, dataz_ID: std_logic_vector(15 downto 0);
	signal rx_ID, ry_ID, rz_ID: std_logic_vector(3 downto 0);
	signal we_ID, oe_ID: std_logic;
	
	signal op_EX: std_logic_vector(3 downto 0);
	signal datax_EX, datay_EX, dataz_EX: std_logic_vector(15 downto 0);
	signal rx_EX, ry_EX, rz_EX: std_logic_vector(3 downto 0);	
	signal we_EX, oe_EX: std_logic;
	
	-- EX_MEM
	signal addr_EX: std_logic_vector(15 downto 0);
	signal din_EX: std_logic_vector(15 downto 0);
	
	signal rz_MEM: std_logic_vector(3 downto 0);
	signal we_MEM, oe_MEM: std_logic;
	signal addr_MEM: std_logic_vector(15 downto 0);
	signal din_MEM: std_logic_vector(15 downto 0);
	
	-- MEM_WB
	signal dataz_MEM: std_logic_vector(15 downto 0);
			
	signal rz_WB: std_logic_vector(3 downto 0);
	signal dataz_WB: std_logic_vector(15 downto 0);
	
	--Ohters
	signal pc_branch: std_logic_vector(15 downto 0);
	signal pc_ctrl: std_logic;
	signal rx_reg, ry_reg: std_logic_vector(3 downto 0);
	signal datax_reg, datay_reg: std_logic_vector(15 downto 0);
	signal dout_MEM: std_logic_vector(15 downto 0);
	signal dataz_ALU: std_logic_vector(15 downto 0);
		
begin

	u1: IF_ID port map(
		clk => clk,
		rst => rst,
		stop => stop,
		bubble => bubble,
		int => int,
		pc_IF => pc_IF,
		ins_IF => ins_IF,
		pc_ID => pc_ID,
		ins_ID => ins_ID
	);
	
	u2: ID_EX port map(
		clk => clk,
		rst => rst,
		stop => stop,
		bubble => bubble,
		int => int,
		op_ID => op_ID,
		datax_ID => datax_ID,
		datay_ID => datay_ID,
		dataz_ID => dataz_ID,
		rx_ID => rx_ID,
		ry_ID => ry_ID,
		rz_ID => rz_ID,
		we_ID => we_ID,
		oe_ID => oe_ID,
		op_EX => op_EX,
		datax_EX => datax_EX,
		datay_EX => datay_EX,
		dataz_EX => dataz_EX,
		rx_EX => rx_EX,
		ry_EX => ry_EX,
		rz_EX => rz_EX,
		we_EX => we_EX,
		oe_EX => oe_EX
	);
	
	u3: EX_MEM port map(
		clk => clk,
		rst => rst,
		stop => stop,
		bubble => bubble,
		rz_EX => rz_EX,
		we_EX => we_EX,
		oe_EX => oe_EX,
		addr_EX => addr_EX,
		din_EX => din_EX,
		
		rz_MEM => rz_MEM,
		we_MEM => we_MEM,
		oe_MEM => oe_MEM,
		addr_MEM => addr_MEM,
		din_MEM => din_MEM
	);
	
	u4: MEM_WB port map(
		clk => clk,
		rst => rst,
		stop => stop,
		rz_MEM => rz_MEM,
		dataz_MEM => dataz_MEM,
		rz_WB => rz_WB,
		dataz_WB => dataz_WB
	);
	
	u5: PC_Choose port map(
		clk => clk,
		rst => rst,
		stop => stop,
		bubble => bubble,
		int => int,
		pc_branch => pc_branch,
		pc_ctrl => pc_ctrl,
		pc_IF => pc_IF
	);
	
	u6: Identify port map(
		ins_ID => ins_ID,
		pc_ID => pc_ID,
		rz_EX => rz_EX,
		dataz_EX => dataz_EX,
		rz_MEM => rz_MEM,
		dataz_MEM => dataz_MEM,
		
		rx_reg => rx_reg,
		datax_reg => datax_reg,
		ry_reg => ry_reg,
		datay_reg => datay_reg,
		
		pc_ctrl => pc_ctrl,
		pc_branch => pc_branch,
		
		op_ID => op_ID,
		we_ID => we_ID,
		rx_ID => rx_ID,
		datax_ID => datax_ID,
		ry_ID => ry_ID,
		datay_ID => datay_ID,
		rz_ID => rz_ID,
		dataz_ID => dataz_ID
	);
	
	u7: ALU port map(
		op_EX => op_EX,
		datax_EX => datax_EX,
		datay_EX => datay_EX,
		dataz_ALU => dataz_ALU
	);
	
	u8: Memory_Manager port map(
		clk => clk,
		rst => rst,
	
		pc_IF => pc_IF,
		ins_IF => ins_IF,
		
		oe_MEM => oe_MEM,
		we_MEM => we_MEM,
		addr_MEM => addr_MEM,
		din_MEM => din_MEM,
		dout_MEM => dout_MEM,
		
		ram1_oe => ram1_oe,
		ram1_we => ram1_we,
		ram1_en => ram1_en,
		ram1_address => ram1_address,
		ram1_data => ram1_data,
		
		rdn => rdn,
		wrn => wrn,
		data_ready => data_ready,
		tbre => tbre,
		tsre => tsre
	);
	
	u9: Register_Heap port map(
		clk => clk,
		rst => rst,
		rx_reg => rx_reg,
		ry_reg => ry_reg,
		datax_reg => datax_reg,
		datay_reg => datay_reg,
		rz_WB => rz_WB,
		dataz_WB => dataz_WB
	);
	
	-- MEM_Choose
	din_EX <= dataz_EX when  (oe_EX or we_EX) = '1' else dataz_ALU;
	addr_EX <= dataz_ALU when (oe_EX or we_EX) = '1' else dataz_EX;
	
	-- WB_Choose
	dataz_MEM <= dout_MEM when (oe_MEM or we_MEM) = '1' else din_MEM;
	
	-- Bubble_Mananger
	bubble <= '1' when (stop = '1' and ((rx_EX = rz_MEM) or (ry_EX = rz_MEM))) else '0';
	
end Behavioral;
