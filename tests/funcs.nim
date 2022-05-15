import durations

func getCountMilli*(d: Milliseconds): Count =
  d.count

func getCountMicro*(d: Microseconds): Count =
  d.count

func getCountSeconds*(d: Seconds): Count =
  d.count
