#!/usr/bin/env bash

function curl_status() {
  curl -s -o /dev/null -w "%{http_code}" "$1"
}
