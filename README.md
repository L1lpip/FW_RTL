# FW_RTL


Version: 2.1
Date: 6/4/2026
Update: Fix the Tvalid match timming with data comming out from Tdata, User IP is validated then output data and tvalid, if not only flush data from fifo and tvalid assert low.

Next_version: Add IP block to calculate data rate, need to output full packet for calculating data rate.

Suggestion: Need to choose time window like: 1ms, 10ms, 1s,... the system will base on that window to calculate.
- Counting incoming bytes of the FireWall IP block.
- Avoid division in system.

Version: 3.0
Date: 13/4/2026
Update: Fix Byte_cnt, add BRAM to store byte_cnt.

Next_version: Add BRAM to store data rate for User ID, add count data rate base on last byte_cnt. Add reconfig for an already existed IP in mem, (eg. IP: abcd is valid[1] but after some clock it reconfig to [0]) -> require status check wether it is inside mem or not then overwrite the old config -> purpose: if an IP is configed as valid calculate it's data rate as normal but if user reconfig the IP then reset the count_by -> data rate = 0, if the config is valid again -> calculate data rate as normal.


Version: 3.1
Date: 14/4/2026
Update: Add bram to store each user data rate, add total byte cnt for all users, add user data_rate calc.

Next_version: 
- Fix the data_rate calculation to data_rate = [IP total byte_cnt]/(total byte_cnt of all IP) in window time t.
- Add reconfig for an already existed IP in mem, (eg. IP: abcd is valid[1] but after some clock it reconfig to [0]) -> require status check wether it is inside mem or not then overwrite the old config -> purpose: if an IP is configed as valid calculate it's data rate as normal but if user reconfig the IP then reset the count_by -> data rate = 0, if the config is valid again -> calculate data rate as normal.