#!/bin/python3

# Import libraries
import transmissionrpc

# Get Transmission info
info = transmissionrpc.Client('192.168.178.57')

# Get all torrents
torrents = info.get_torrents()

# Get torrent info
for torrent in torrents:
	print(torrent.name)
	print(torrent.status)
	print(torrent.rateDownload)
	print(torrent.rateUpload)

# Debug echo's
