#!/bin/bash

setupFiles $(find .config -type f 2>/dev/null)
setupFiles '.local/share/file-manager/actions'
