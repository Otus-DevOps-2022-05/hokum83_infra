def test_mongodb_is_running(host):
    mongodb = host.socket('tcp://127.0.0.1:27017')
    assert mongodb.is_listening
