/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000001573313991_0619962294_init();
    work_m_00000000002976436205_0935055358_init();
    work_m_00000000001662062654_1931955998_init();
    work_m_00000000002738371156_2002060500_init();
    work_m_00000000000197330456_0182372474_init();
    work_m_00000000001304455177_4283663877_init();
    work_m_00000000000339650694_1532905740_init();
    xilinxcorelib_ver_m_00000000001358910285_1414349110_init();
    xilinxcorelib_ver_m_00000000001687936702_3394062426_init();
    xilinxcorelib_ver_m_00000000000277421008_1195644284_init();
    xilinxcorelib_ver_m_00000000001603977570_3721372091_init();
    work_m_00000000002489990758_1220562159_init();
    xilinxcorelib_ver_m_00000000001358910285_1620489502_init();
    xilinxcorelib_ver_m_00000000001687936702_1928756901_init();
    xilinxcorelib_ver_m_00000000000277421008_2360425968_init();
    xilinxcorelib_ver_m_00000000001603977570_3171308256_init();
    work_m_00000000002489990758_2987052570_init();
    xilinxcorelib_ver_m_00000000001358910285_0413834162_init();
    xilinxcorelib_ver_m_00000000001687936702_3609483624_init();
    xilinxcorelib_ver_m_00000000000277421008_3515401321_init();
    xilinxcorelib_ver_m_00000000001603977570_2099524215_init();
    work_m_00000000002489990758_0616766566_init();
    xilinxcorelib_ver_m_00000000001358910285_0690254293_init();
    xilinxcorelib_ver_m_00000000001687936702_3549473565_init();
    xilinxcorelib_ver_m_00000000000277421008_4118169394_init();
    xilinxcorelib_ver_m_00000000001603977570_2382206998_init();
    work_m_00000000002489990758_3348011992_init();
    work_m_00000000001658554456_3823007873_init();
    work_m_00000000001078802773_0606222146_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000001078802773_0606222146");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
