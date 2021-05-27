-- FIXME: the content of the binary file generated by this test is significantly different from the *_bin test.
-- This output is incorrect (cannot be read from Matlab with fread 'double').
-- Need to check the LRM and/or ask Trista/Patrick/Jim.

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_soft_singleproc_binvec is
  generic (
    runner_cfg : string;
    tb_path: string
  );
end entity;

library ieee;
context ieee.ieee_std_context;

architecture arch of tb_soft_singleproc_binvec is

  constant Ts : time := 20 ms;
  constant cycles : integer := 12 sec / Ts;

  constant Kp : real := 1250.0;

  constant Nd : real := 1.9990e-05;
  constant Dd : real := -0.9990;

begin

  p_main: process
    variable r, e, u, y: real;

    subtype y_vec is real_vector(0 to cycles);
    -- Temporary vector to save plant output values
    variable yv : y_vec;

    constant output_filename : string := tb_path & "../soft_singleproc_binvec.bin";
    -- Define the type of the data as a unidimensional vector
    type realvec_file is file of y_vec;
    file fptr : realvec_file;
    variable fstat : file_open_status;
  begin
    test_runner_setup(runner, runner_cfg);
    report "start simulation";

    y := 0.0;
    r := 10.0;

    for k in 0 to cycles loop
      -- Save current plant output to temporary vector
      yv(k) := y;

      e := r-y;
      u := Kp * e;

      y := Nd * u - Dd * y;
    end loop;

    -- Open file, write temporary vector and close file
    file_open(fstat, fptr, output_filename, write_mode);
    write(fptr, yv);
    file_close(fptr);

    report "end of test";
    test_runner_cleanup(runner);
    wait;
  end process;

end arch;