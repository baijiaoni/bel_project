--! Standard library
library IEEE;
--! Standard packages    
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--! Additional library
library work;
--! Additional packages    
--use work.NIC_constants_pkg.all;


package PACKET_HDR_pkg is

-- tx only
constant cIP_ver_hlen_difserv : std_logic_vector(15 downto 0) := "0100010100000000";
constant cIP_id               : std_logic_vector(15 downto 0) := "0000000000000000";
constant cIP_flags_fragOffset : std_logic_vector(15 downto 0) := "0100000000000000";
constant cIP_ttl_proto        : std_logic_vector(15 downto 0) := "0100000000010001";

type IPV4_HDR_TX is record


   
   TOL,
   SUM      :         unsigned(15 downto 0);  
   SRC,     
   DEST     : std_logic_vector(31 downto 0);
end record;

type IPV4_HDR is record

   -- RX only, use constant fields for TX --------
   VER,    
   IHL     : std_logic_vector(3 downto 0);
   TOS     : std_logic_vector(7 downto 0);
   ID      : std_logic_vector(15 downto 0);
   FLG     : std_logic_vector(2 downto 0);
   FRO     : std_logic_vector(12 downto 0);
   TTL     : std_logic_vector(7 downto 0);
   PRO     : std_logic_vector(7 downto 0);
   -----------------------------------------------
   
   TOL,
   SUM      :         unsigned(15 downto 0);  
   SRC,     
   DEST     : std_logic_vector(31 downto 0);

end record;


type UDP_HDR is record
   SRC_PORT,   
   DEST_PORT   : std_logic_vector(15 downto 0);
   MLEN,         
   SUM         :         unsigned(15 downto 0);
end record;

type EB_HDR is record
   -- not actual sequence, changed for coding style.
   -- see EB_PACK_HDR_TO_SLV16 output function for order
   
   ACKF,
   SWABF :                    std_logic;
     
   RPORT ,  
   PRO :   std_logic_vector(7 downto 0);
   
   SAD,     
   ADINC, 
   RCNT,  
   RREM,
   SEQN : unsigned(7 downto 0);
   
end record;

type EB_PACK_HDR is record
   IPV4 : IPV4_HDR;
   UDP  : UDP_HDR;
   EB   : EB_HDR;
end record;



function EB_PACK_HDR_TO_SLV16(index : natural; X : EB_PACK_HDR) return std_logic_vector;

function SLV16_TO_EB_PACK_HDR(index : natural; X : std_logic_vector; HDR : EB_PACK_HDR) return EB_PACK_HDR;

end PACKET_HDR_pkg;

package body PACKET_HDR_pkg is

  -- send out the complete header in 16bit words. 
  -- TX function, uses constant fields.
function EB_PACK_HDR_TO_SLV16(index : natural; X : EB_PACK_HDR)
              return std_logic_vector is
variable tmp: std_logic_vector(15 downto 0) := (others => '0');
begin
  case index is
    -- IPV4 Hdr
    when  0       => tmp := cIP_ver_hlen_difserv;       
    when  1       => tmp := std_logic_vector(X.IPV4.TOL);        
    when  2       => tmp := cIP_id; -- ID
    when  3       => tmp := cIP_flags_fragOffset; 
    when  4       => tmp := cIP_ttl_proto;   
    when  5       => tmp := std_logic_vector(X.IPV4.SUM); 
    when  6       => tmp := X.IPV4.SRC( 31 downto 16); 
    when  7       => tmp := X.IPV4.SRC( 15 downto 0); 
    when  8       => tmp := X.IPV4.DEST(31 downto 16); 
    when  9       => tmp := X.IPV4.DEST(15 downto 0); 
    -- UDP Hdr
    when 10       => tmp := X.UDP.SRC_PORT;
    when 11       => tmp := X.UDP.DEST_PORT;
    when 12       => tmp := std_logic_vector(X.UDP.MLEN);
    when 13       => tmp := std_logic_vector(X.UDP.SUM);
    -- EB Hdr
    when 14       => tmp := X.EB.PRO & std_logic_vector(X.EB.SAD) ;  
    when 15       => tmp := std_logic_vector(X.EB.ADINC) & std_logic_vector(X.EB.RCNT); 
    when 16       => tmp := "0000000" & X.EB.ACKF & "0000000" & X.EB.SWABF; 
    when 17       => tmp := X.EB.RPORT & std_logic_vector(X.EB.RREM); 
    when 18       => tmp := std_logic_vector(X.EB.SEQN) & "00000000"; 
    when 19 to 21 => tmp := "0000000000000000";
    
    when others   => tmp := x"DEAD";
  end case;
  return tmp;             
end EB_PACK_HDR_TO_SLV16;

  -- convert 16b words to EB_PACK_HDR. use 'RX only' fields
function SLV16_TO_EB_PACK_HDR(index : natural; X : std_logic_vector; HDR : EB_PACK_HDR)
              return EB_PACK_HDR is
variable tmp : EB_PACK_HDR := HDR;

begin
  case index is
    -- IPV4 HDR
    when  0       =>  tmp.IPV4.VER  := X(15 downto 12); 
                      tmp.IPV4.IHL  := X(11 downto 8);
                      tmp.IPV4.TOS  := X(7 downto 0);
    when  1       =>  tmp.IPV4.ID   := X;
    when  2       =>  tmp.IPV4.FLG  := X(15 downto 13);
                      tmp.IPV4.FRO  := X(12 downto 0);
    when  3       =>  tmp.IPV4.TTL  := X(15 downto 8);
                      tmp.IPV4.PRO  := X(7 downto 0);
    when  5       =>  tmp.IPV4.SUM  := unsigned(X);
    when  6       =>  tmp.IPV4.SRC( 31 downto 16) := X;
    when  7       =>  tmp.IPV4.SRC( 15 downto 0)  := X; 
    when  8       =>  tmp.IPV4.DEST(31 downto 16) := X;
    when  9       =>  tmp.IPV4.DEST(15 downto 0)  := X;
    -- UDP HDR  
    when 10       =>  tmp.UDP.SRC_PORT  := X;
    when 11       =>  tmp.UDP.DEST_PORT := X;
    when 12       =>  tmp.UDP.MLEN      := unsigned(X); 
    when 13       =>  tmp.UDP.SUM       := unsigned(X);
    -- EB HDR 
    when 14       =>  tmp.EB.PRO        := X(15 downto 8);
                      tmp.EB.SAD        := unsigned(X(7 downto 0));
    when 15       =>  tmp.EB.ADINC      := unsigned(X(7 downto 0));
                      tmp.EB.RCNT       := unsigned(X(7 downto 0));
    when 16       =>  tmp.EB.ACKF       := X(8);
                      tmp.EB.SWABF      := X(0);
    when 17       =>  tmp.EB.RPORT      := X(15 downto 8);
                      tmp.EB.RREM       := unsigned(X(7 downto 0));
    when 18       =>  tmp.EB.SEQN       := unsigned(X);
    
    when others   =>  null;
  end case;                   
  
  return tmp;               
end SLV16_TO_EB_PACK_HDR;

----------------------------------------------------------------------------------

end package body;


