from huobi.client.account import AccountClient
from huobi.vpn_na import *


# get accounts
from huobi.utils import *

account_client = AccountClient(api_key=p_api_key,
                              secret_key=p_secret_key)
list_obj = account_client.get_balance(account_id=p_account_id)
LogInfo.output_list(list_obj)