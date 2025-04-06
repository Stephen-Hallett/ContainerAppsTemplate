import os

import requests
import streamlit as st

st.write(requests.get(f"{os.environ['BACKEND_ENDPOINT']}/test").text)
