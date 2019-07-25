#!/usr/bin/python3

import time
import vncdowrap
import sys
print('Starting test...')

verbose=False

testStatus=[]

vncdo = vncdowrap.vncdowrap()

def failureHandler(what, reason="", errorCode=None):
	if len(reason) is not 0:
		print('   \u21b1  ', reason)
	print('[FAIL]', what)
	if errorCode is not None:
		testStatus.append(errorCode)

if verbose:
	print('Waiting for GRUB boot menu...')
try:
	vncdo.expectScreen('screendumps/grub-boot-menu.png', 0, 10)
	print('[OK] GRUB boot menu')
except RuntimeError as re:
	failureHandler('GRUB boot menu', re.args[0], 1)
except Exception as e:
	failureHandler('GRUB boot menu', e, 1)

# Test for false positve.
try:
	vncdo.expectScreen('screendumps/grub-boot-menu2.png', 2)
	failureHandler('GRUB boot menu false positive', "", 2)
except AssertionError:
	print('[OK] GRUB boot menu false positive')

if verbose:
	print('Pressing enter...')
try:
	vncdo.keyPress('enter')
except Exception as e:
	failureHandler('GRUB boot menu enter', e, 3)

if verbose:
	print('Waiting for clean GRUB splash screen...')
try:
	vncdo.expectScreen('screendumps/grub-clean-splash-screen.png', 0, 5)
	print('[OK] GRUB clean splash screen')
except RuntimeError as re:
	failureHandler('GRUB clean splash screen', re.args[0], 4)
except Exception as e:
	failureHandler('GRUB clean splash screen', e, 4)

if verbose:
	print('Waiting for desktop...')
try:
	vncdo.expectScreen('screendumps/desktop.png', 5, 120)
	print('[OK] Desktop logged in')
except RuntimeError as re:
	failureHandler('Desktop logged in', re.args[0], 5)
except Exception as e:
	failureHandler('Desktop logged in', e, 5)

print('Test done!')

print('Found %d error(s): ' % len(testStatus), *testStatus)

exit(len(testStatus))
