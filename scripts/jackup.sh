jackd -d dummy&
sleep 5
jack_connect dirt:output_0 ffmpeg:input_1
jack_connect dirt:output_1 ffmpeg:input_2
