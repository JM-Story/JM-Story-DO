#!/bin/bash
apt-get update -y
apt-get install -y openvpn easy-rsa

make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa
# 여기에 CA 키, 서버 인증서 생성, 서버.conf 설정 등을 자동화로 추가 가능