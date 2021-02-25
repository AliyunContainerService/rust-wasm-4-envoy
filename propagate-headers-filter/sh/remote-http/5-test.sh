#!/usr/bin/env sh
echo "localhost:18000:"
curl -H "version-tag":"v1" "localhost:18000"
echo "\nlocalhost:18000/hello:"
curl -H "version-tag":"v2" "localhost:18000/hello"
echo "\nlocalhost:18000/hello?star=black:"
curl -H "version-tag":"v3" "localhost:18000/hello?star=black"
echo "\nlocalhost:18000/hello?star=black&number=5"
curl -H "version-tag":"v3" "localhost:18000/hello?star=black&number=5"