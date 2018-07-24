import pandas
import json
from fbprophet import Prophet

def get_df_from_json(metric):
    print("Here")
    '''
    Method to convert a json object of a Prometheus metric to a dictionary of shaped Pandas DataFrames

    The shape is dict[metric_metadata] = Pandas Object

    Pandas Object = timestamp, value
                    15737933, 1
                    .....
    '''
    # metric_dict = {}
    print("Shaping Data...........")
    metric_dict_pd = {}
    print("Length of metric: ", len(metric))
    for row in metric:
        # metric_dict[str(row['metric'])] = metric_dict.get(str(row['metric']),[]) + (row['values'])
        metric_metadata = str(row['metric'])
        print(metric_metadata)
        print("Row Values: ",row['values'])
        if  metric_metadata not in metric_dict_pd:
            metric_dict_pd[metric_metadata] = pandas.DataFrame(row['values'], columns=['timestamp', 'value'])
            pass
        else:
            temp_df = pandas.DataFrame(row['values'], columns=['timestamp', 'value'])
            print(temp_df.head())
            # print("Row Values: ",row['values']
            metric_dict_pd[metric_metadata] = pandas.concat([metric_dict_pd[metric_metadata], temp_df])
            # del temp_df
            pass
        pass
        break
        # metric_dict_pd[metric_metadata].set_index('timestamp')
    return metric_dict_pd
