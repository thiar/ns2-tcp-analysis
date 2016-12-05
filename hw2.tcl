# Create a new simulator object
set ns [new Simulator]

# Enable the nam trace
$ns trace-all [open hw2.tr w]
$ns namtrace-all [open hw2.nam w]

# Create the following procedure which launches nam
proc finish {} {
      global ns
      $ns flush-trace
      puts "filtering..."
      puts "running nam..."
      exec nam -a hw3.nam &
      exit 0
}

# Creates four nodes n0, n1, n2, n3
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Create the following topology, where
# n0 and n1 are connected by a duplex-link with
# capacity 5Mbps, propagation delay 20ms, dropping
# discipline "DropTail".
$ns duplex-link $n0 $n1 5Mb 20ms DropTail

# n1 and n2 are connected by a duplex-link with
# capacity 0.5Mbps, propagation delay 100ms, and
# dropping discipline "DropTail".
$ns duplex-link $n1 $n2 0.5Mb 100ms DropTail

# n2 and n3 connected by a duplex-link with capacity 5Mbps,
# propagation delay 20ms, dropping discipline "DropTail".
$ns duplex-link $n2 $n3 5Mb 20ms DropTail

# Create a bottleneck between n1 and n2, with a maximum queue
# size of 5 packets
$ns queue-limit $n1 $n2 5

# Instruct nam how  to display the nodes
$ns duplex-link-op  $n0 $n1 orient right
$ns duplex-link-op  $n1 $n2 orient right
$ns duplex-link-op  $n2 $n3 orient right
$ns duplex-link-op  $n1 $n2 queuePos 0.5

# Establish a TCP (Reno) connection between n0 and n3
set tcp [new Agent/TCP/Vegas]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

# Create an FTP transfer (using the TCP agent)
# between n0 and n3
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Start the data transfer:
$ns at 0.1 "$ftp start"
$ns at 5.0 "$ftp stop"

# Launch the animation
$ns at 5.1 "finish"

# procedure to plot the congestion window
proc plotWindow {tcpSource outfile} {
   global ns
   set now [$ns now]
   set cwnd [$tcpSource set cwnd_]

# the data is recorded in a file called congestion.xg (this can be plotted # using xgraph or gnuplot. this example uses xgraph to plot the cwnd_
   puts  $outfile  "$now $cwnd"
   $ns at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
}

set outfile [open  "congestion.xg"  w]
$ns  at  0.0  "plotWindow $tcp  $outfile"
proc finish {} {
 exec xgraph congestion.xg -geometry 300x300 &;
   exit 0
}

$ns run
