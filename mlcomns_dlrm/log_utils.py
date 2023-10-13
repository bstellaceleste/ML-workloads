from datetime import datetime

# UTC timestamp format with microsecond precision
LOG_TS_FORMAT = "%Y-%m-%dT%H:%M:%S.%f"

def utcnow(format=LOG_TS_FORMAT):
    return datetime.utcnow().strftime(format)