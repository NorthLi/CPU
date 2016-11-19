library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Thinpad is
end Thinpad;

architecture Behavioral of Thinpad is

	component IF_ID is
		port(
			clk: in std_logic;
			stop, bubble: in std_logic;
			int: in std_logic;
			
			pc_IF:in std_logic_vector(15 downto 0);
			ins_IF: in std_logic_vector(15 downto 0);
			
			pc_ID:out std_logic_vector(15 downto 0);
			ins_ID: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component ID_EX is
		port(
			clk:in std_logic;
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
			clk: in std_logic;
			stop: in std_logic;
			
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
			clk:in std_logic;
			stop: in std_logic;
			
			rz_MEM: in std_logic_vector(2 downto 0);
			dataz_MEM: in std_logic_vector(15 downto 0);
			
			rz_WB: out std_logic_vector(2 downto 0);
			dataz_WB: out std_logic_vector(15 downto 0)	
		);
	end component;
	
	component PC_Choose is
		port(
			clk: in std_logic;
			stop, bubble:in std_logic;
			int: in std_logic;
			
			pc_IF: in std_logic_vector(15 downto 0);
			pc_branch: in std_logic_vector(15 downto 0);
			pc_ctrl: in std_logic;
			
			pc_new: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Identify is
		port(
			ins: in std_logic_vector(15 downto 0);
			pc_ID: in std_logic_vector(15 downto 0);
			
			rz_EX, rz_MEM: in std_logic_vector(3 downto 0);
			dataz_EX, dataz_MEM: in std_logic_vector(15 downto 0);
			
			rx_reg, ry_reg: out std_logic_vector(3 downto 0);
			datax_reg, datay_reg: in std_logic_vector(15 downto 0);
			
			pc_ctrl:out std_logic;
			pc_branch: out std_logic_vector(15 downto 0);
			
			op: out std_logic_vector(3 downto 0);
			we_ID, oe_ID: out std_logic;
			rx_ID, ry_ID, rz_ID: out std_logic_vector(3 downto 0);
			datax_ID, datay_ID, dataz_ID: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Register_Manager is
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
			data_ALU: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Memory_Manager is
		port(
			clk:in std_logic;
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
	
	component MEM_Choose is
		port(
			en: in std_logic;
			data_ALU: in std_logic_vector(15 downto 0);
			dataz_EX: in std_logic_vector(15 downto 0);
			
			din_EX: out std_logic_vector(15 downto 0);
			addr_EX: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component WB_Choose is
		port(
			en: in std_logic;
			din_MEM, dout_MEM: in std_logic_vector(15 downto 0);			
			
			dataz_MEM: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component Bubble_Manager is
		port(
			rx_EX, ry_EX: in std_logic_vector(15 downto 0);
			rz_MEM: in std_logic_vector(15 downto 0);
			oe_MEM: in std_logic;
			
			bubble: out std_logic
		);
	end component;
	
begin

end Behavioral;
