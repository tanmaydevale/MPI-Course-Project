# MPI-Course-Project

Design a microprocessor-based transistor h FE tester. The system has to display the hFE value
of NPN transistors.

The base of the TUT is energized with a current I from a device DI. The current I can be
controlled by DC supply voltage V.
I = V * 10 μA

Current range is 1-10μA.
Resolution required is 1μA.
Emitter of the transistor is grounded.
Collector is connected to a 1K resistor whose other end is connected to the +5V supply.
Voltage drop across a 1K resistor is measured and this is related to the hFE by the
following relation:
h FE * I * 1000 = Voltage Drop
If the h FE value is less than 20, an alarm should be sounded.
