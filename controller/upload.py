# !/usr/bin/python
import MySQLdb
from scapy.all import *

''' transfer int information to table int_info in database INT_INFO. '''


class Upload:

    def __init__(self, int_dict, paths):
        self.int_dict = int_dict
        self.paths = paths
        self.insert_info()

    def insert_info(self):
        db = MySQLdb.connect(host='localhost',
                             user='root',
                             passwd='233233',
                             db='INT_INFO',
                             charset='utf8')
        cue = db.cursor()
        print("mysql connect succes")

        # #  insert paths
        # path_id = self.paths[0]
        # paths_tmp = self.paths[::-1]
        # index_start = []
        # index_end = []
        # for i in range(len(paths_tmp)):
        #     if paths_tmp[i] == "start":
        #         index_start.append(i)
        # for i in range(len(paths_tmp)):
        #     if paths_tmp[i] == "end":
        #         index_end.append(i)
        # print(index_start)
        # print(index_end)
        # new_paths = []
        # for i in range(len(index_start)):
        #     tmp = '|'.join(paths_tmp[index_start[i] + 1:index_end[i]])
        #     new_paths.append(tmp)
        # print(new_paths)
        # pathNum = len(new_paths)
        # for n in range(pathNum):
        #     try:
        #         cue.execute("insert into dfs_path_heavy (path_id, path) values(%s, %s)", [path_id, new_paths[n]])
        #     except Exception as e:
        #         print('Insert error:', e)
        #         db.rollback()
        #     else:
        #         db.commit()
        # db.close()

        #  insert int information
        switchNum = len(self.int_dict['switch_id'])
        for i in range(switchNum):
            switchID = self.int_dict['switch_id'][i]
            inPort = self.int_dict['ingress_port'][i]
            ePort = self.int_dict['egress_port'][i]
            ingressTstamp = self.int_dict['ingress_tstamp'][i]
            enqTstamp = self.int_dict['enq_tstamp'][i]
            proDelay = enqTstamp - ingressTstamp
            queDelay = self.int_dict['deq_timedelta'][i]
            enqQdepth = self.int_dict['enq_qdepth'][i]
            deqQdepth = self.int_dict['deq_qdepth'][i]
            if i == (switchNum - 1):
                switchID_follow = 0
            else:
                switchID_follow = self.int_dict['switch_id'][i + 1]
            try:
                cue.execute("insert into dfs_int_heavy (switch_id, next_switch_id, ingress_port, egress_port, "
                            "enq_tstamp, ingress_tstamp, deq_timedelta, process_delay, enq_qdepth, deq_qdepth) "
                            "values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                            [switchID, switchID_follow, inPort, ePort, enqTstamp, ingressTstamp, queDelay, proDelay,
                             enqQdepth, deqQdepth])
                print("insert success [%d]" % i)
            except Exception as e:
                print('Insert error:', e)
                db.rollback()
            else:
                db.commit()
        db.close()


if __name__ == "__main__":
    pass
