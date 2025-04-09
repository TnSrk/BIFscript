#/home/puppy/AUTOGUI/bin/python3
import pyautogui as p
import time as t
import sys
import csv
import random
from datetime import datetime

ProvinceL = "Bangkok,Amnat Charoen,Ang Thong,Bueng Kan,Buriram,Chachoengsao,Chai Nat,Chaiyaphum,Chanthaburi,Chiang Mai,Chiang Rai,Chonburi,Chumphon,Kalasin,Kamphaeng Phet,Kanchanaburi,Khon Kaen,Krabi,Lampang,Lamphun,Loei,Lopburi,Mae Hong Son,Maha Sarakham,Mukdahan,Nakhon Nayok,Nakhon Pathom,Nakhon Phanom,Nakhon Ratchasima,Nakhon Sawan,Nakhon Si Thammarat,Nan,Narathiwat,Nong Bua Lamphu,Nong Khai,Nonthaburi,Pathum Thani,Pattani,Phang Nga,Phatthalung,Phayao,Phetchabun,Phetchaburi,Phichit,Phitsanulok,Phra Nakhon Si Ayutthaya,Phrae,Phuket,Prachinburi,Prachuap Khiri Khan,Ranong,Ratchaburi,Rayong,Roi Et,Sa Kaeo,Sakon Nakhon,Samut Prakan,Samut Sakhon,Samut Songkhram,Saraburi,Satun,Sing Buri,Sisaket,Songkhla,Sukhothai,Suphan Buri,Surat Thani,Surin,Tak,Trang,Trat,Ubon Ratchathani,Udon Thani,Uthai Thani,Uttaradit,Yala,Yasothon,Other,Ayutthaya".split(",")

def RS(T=2):
	t.sleep((random.randrange(1,T)*10.0)/10.0)

def wtab(InStr, E=False):
	p.write(str(InStr))
	if (E==True):
		p.press('enter')
	RS()
	p.press('tab')	

def ThProvincer(InStr="Other"):

	if InStr in ProvinceL:
		wtab(InStr,E=True)
	else:
		p.press('up',1)
		t.sleep(0.5)
		p.write(InStr)
		p.press('enter')
		p.press('tab')	

def wchoice(InNum,Tab=True):
	p.press('space')
	t.sleep(0.8)
	p.press('down',InNum)
	t.sleep(0.8)
	p.press('enter')
	t.sleep(1)
	if (Tab==True) :
		p.press('tab')
		RS()

def choicer(InDict,colNameStr,choiceL):
	matchB = False
	for i in range(len(choiceL)):
		if ((InDict[colNameStr]).lower() == choiceL[i].lower()):
			wchoice(i+1)
			matchB = True

	if (matchB == False):
		p.press('tab')

def dumb_choicer(InDict,colNameStr,choiceL,FindCharNum=2):
	matchB = False
	for i in range(len(choiceL)):
		if ((InDict[colNameStr]).lower() == choiceL[i].lower() or ( InDict[colNameStr].find(choiceL[i].lower()[:FindCharNum]) > -1 ) ) :
			wchoice(i+1)
			matchB = True

	if (matchB == False):
		p.press('tab')

def dater(InDict,colNameStr):
	if (bool_dateChk(InDict[colNameStr])):
		#wtab(InDict['symptomDate'], True )
		p.write(InDict[colNameStr])
		#t.sleep(1)
		p.press('enter')
		t.sleep(1)
		p.press('tab')
		
	else:
		p.press('tab')

def tf(InDict,colNameStr):
	if (InDict[colNameStr].strip().lower() == "true"):
		wchoice(1)
	elif (InDict[colNameStr].strip().lower() == "false"):
		wchoice(2)
	else:
		p.press('tab')
		t.sleep(1)
def nf(InDict,colNameStr):
	if ( InDict[colNameStr].isdecimal() or ( (len(InDict[colNameStr].strip().split(".")) == 2) and (InDict[colNameStr].strip().split(".")[0].isdecimal())  and (InDict[colNameStr].strip().split(".")[1].isdecimal()) )):
		wtab(InDict[colNameStr])
	else:
		p.press('tab')

def csv_to_dict(file_path):
	result = []

	with open(file_path, 'r', newline='') as csvfile:
		# DictReader automatically uses first row as headers
		reader = csv.DictReader(csvfile)

		# Convert each row to dictionary and add to result list
		for row in reader:
			result.append(row)

	return result

def bool_dateChk(date_string,DplitChar="-",OrderL=[0,1,2]):
	try:
		# Split the date string (assuming YYYY-MM-DD)
		#year, month, day = map(int, date_string.split('-'))
		
		#year, month, day = map(int, date_string.split(DplitChar))
		DateL = date_string.split(DplitChar)
		year = DateL[OrderL[0]]
		month = DateL[OrderL[1]]
		day = DateL[OrderL[2]]

		
		# Basic range checks
		if not (1 <= month <= 12):
			return False
		if not (1 <= day <= 31):
			return False
		if not (1 <= year <= 9999):  # Arbitrary upper limit
			return False
		
		# Try creating a datetime object for final validation
		datetime(year, month, day)
		return True
	except (ValueError, IndexError):
		return False


def formFill(InDict):
	xp = 673	
	yp = 148
	p.click(xp,yp)
	#t.sleep(1)
	p.press('f5')
	t.sleep(5)

	p.click('BTN/addB.png')
	RS(2)
	p.click('BTN/1stF.png')
	RS(2)
	wtab(InDict['redcapId']) #fill redcapId
	wtab("") #fill genbankID as blank
	wtab(InDict['labCode'])
	
	#fill sex field
	if(InDict['sex'].lower() == "male"):
		wchoice(1)
	elif(InDict['sex'].lower() == "female"):
		wchoice(2)
	else:
		p.press('tab')

	wtab(InDict['age']) #fill age field

	if ((InDict['ethnics']).lower() == "thai"):
		wchoice(1)
	elif ((InDict['ethnics']).lower() == "seas"):
		wchoice(2)
	elif ((InDict['ethnics']).lower() == "caucasian"):
		wchoice(3)
	elif ((InDict['ethnics']).lower() == "other"):
		wchoice(4)
	else:
		p.press('tab')

	#Height
	if ( InDict['height'].isdecimal() or ( (len(InDict['height'].strip().split(".")) == 2) and (InDict['height'].strip().split(".")[0].isdecimal())  and (InDict['height'].strip().split(".")[1].isdecimal()) )):
		wtab(InDict['height'])
	else:
		p.press('tab')

	#Weight
	if(InDict['weight'].isdecimal()):
		wtab(InDict['weight'])
	else:
		p.press('tab')

	#fill pregnant field
	if ((InDict['sex']).lower() == "female"):
		if ((InDict['pregnant']).lower() == "true"):
			wchoice(1)

		elif ((InDict['pregnant']).lower() == "false"):
			wchoice(2)
		else:
			p.press('tab')

	else:
		p.press('tab')

	#fill source
	if ((InDict['source']).lower() == "bkk"):
		wchoice(1)
	elif ((InDict['source']).lower() == "rural"):
		wchoice(2)
	elif ((InDict['source']).lower() == "rural"):
		wchoice(2)
	else:
		p.press('tab')

	#Symptop date
	if (bool_dateChk(InDict['symptomDate'])):
		#wtab(InDict['symptomDate'], True )
		p.write(InDict['symptomDate'])
		#t.sleep(1)
		p.press('enter')
		t.sleep(1)
		p.press('tab')
		
	else:
		p.press('tab')
	t.sleep(1)
	#diagnosisDate
	if (bool_dateChk(InDict['diagnosisDate'])):
		#wtab(InDict['diagnosisDate'], True )
		p.write(InDict['diagnosisDate'])
		#t.sleep(1)
		p.press('enter')
		t.sleep(1)
		p.press('tab')
		
	else:
		p.press('tab')
	#p.press('pgdn')
	#p.press('pgdn')
	#p.scroll(-2)
	# admittedDate
	t.sleep(1)
	if (bool_dateChk(InDict['admittedDate'])):
		#wtab(InDict['admittedDate'], True )		
		p.write(InDict['admittedDate'])
		#t.sleep(1)
		p.press('enter')
		t.sleep(1)
		p.press('tab')
		
	else:
		p.press('tab')

	# previousVaccine
	#VCL = InDict['previousVaccine'].strip().split(",")
	#p.press('pgdn')
	#p.press('pgdn')
	t.sleep(1)
	p.scroll(-1)
	t.sleep(1.2)
	if (InDict['previousVaccine'] == ""):
		p.press('tab')
	else:
		VCL = InDict['previousVaccine'].strip().split(",")
		if (len(VCL) > 1):
			print("len(VCL)=",len(VCL))
			pr = './BTN/prvVc.png'
			x,y,w,h = p.locateOnScreen(pr)
			for i in range(1, len(VCL)):
				p.click(x+w,y+h)
				t.sleep(1.5)
				
			t.sleep(1)
			p.hotkey('shift','tab')
			t.sleep(1)
			
			
		if (len(VCL) >=1):
			
			if (VCL[0].lower() == "az"):
				wchoice(1,False)
			elif (VCL[0].lower() == "sv"):
				wchoice(2,False)
			elif (VCL[0].lower() == "sp"):
				wchoice(3,False)
			elif (VCL[0].lower() == "pz" or VCL[0].lower() == "pf"):
				wchoice(4,False)
			elif (VCL[0].lower() == "md"):
				wchoice(5,False)
			elif (VCL[0].lower().find("chula") > -1 ):
				wchoice(6,False)

			#p.hotkey('ctr','shift','+','+','+','+','+')
			t.sleep(1)
			p.press('space')
			p.press('enter')
					
		t.sleep(1.5)
		
		for i in range(1, len(VCL)):
			#pr = './BTN/prvVc.png'
			#x,y,w,h = p.locateOnScreen(pr)
			#if (i > 1):
				#pr = './BTN/prvVc1.png'
			#	print('XXX')
			t.sleep(1.5)

			p.press('tab')
			p.press('space')
			p.press('space')
			print(pr,VCL[i])
			
			if (VCL[i].lower() == "az"):
				#p.click(pr)				
				
				t.sleep(1.5)
				wchoice(1,False)
				
			elif (VCL[i].lower() == "sv"):
				#p.click(pr)				
				#p.press('tab')
				#p.press('space')
				t.sleep(1.5)
				wchoice(2,False)
			elif (VCL[i].lower() == "sp"):
				#p.click(pr)				
				#p.press('tab')
				#p.press('space')
				t.sleep(1.5)
				wchoice(3,False)
			elif (VCL[i].lower() == "pz" or VCL[i].lower() == "pf"):
				#p.click(pr)				
				#p.press('tab')	
				#p.press('space')
				t.sleep(1.5)
				wchoice(4,False)
			elif (VCL[i].lower() == "md"):
				#p.click(pr)
				#p.press('tab')
				#p.press('space')
				t.sleep(1.5)				
				wchoice(5,False)
			elif (VCL[i].lower().find("chula") > -1 ):
				#p.click(pr)				
				#p.press('tab')
				#p.press('space')
				t.sleep(1.5)
				wchoice(6,False)
				
			t.sleep(1.5)
			p.press('enter')
		#p.hotkey('ctr','0')
		t.sleep(1.5)
		p.scroll(-2)
		p.press('tab')

	# doseAZmRNA
	if(InDict['doseAZmRNA'].isdecimal()):
		wtab(InDict['doseAZmRNA'])
	else:
		p.press('tab')

	# lastAZmRNAToSymptomMonth
	if(len(InDict['lastAZmRNAToSymptomMonth']) < 2 ):
		p.press('tab')
		
	elif (InDict['lastAZmRNAToSymptomMonth'].find(">6") > -1):
		t.sleep(1.5)
		#p.press('space')
		wchoice(7)

	elif ( (InDict['lastAZmRNAToSymptomMonth'].strip()[1].isdecimal() == True ) and int(InDict['lastAZmRNAToSymptomMonth'].strip()[1]) < 7 and int(InDict['lastAZmRNAToSymptomMonth'].strip()[1] > 0)):
		t.sleep(1.5)
		#p.press('space')
		wchoice(int(InDict['lastAZmRNAToSymptomMonth'].strip()[1]))
	else:
		p.press('tab')

	# caseExpose
	"""
	if (InDict['caseExpose'].strip().lower() == "true"):
		wchoice(1)
	elif (InDict['caseExpose'].strip().lower() == "false"):
		wchoice(2)
	else:
		p.press('tab')
		t.sleep(1)
	"""
		
	# "caseExpose,nursingCare,cvsRisk,lungRisk,dmRisk"
	ColstrL = "caseExpose,nursingCare,cvsRisk,lungRisk,dmRisk".split(",")
	
	for i in ColstrL:
		tf(InDict,i)
	
	# hba1c
	nf(InDict,'hba1c')

	# "neuroRisk,liverRisk,ckdRisk,cancerRisk,immunosupRisk,fever,dyspnea,cough,soreThroat,coryza,myalgia,headache,nausea,diarrhea,anosmia"
	ColstrL = "neuroRisk,liverRisk,ckdRisk,cancerRisk,immunosupRisk,fever,dyspnea,cough,soreThroat,coryza,myalgia,headache,nausea,diarrhea,anosmia".split(",")
	for i in ColstrL:
		tf(InDict,i)

	# "bloodHB,bloodWBC,bloodLymph,bloodPlatelet,bloodBUN,bloodCr,bloodAlbumin,enzymeSGOT,enzymeSGPT,procalcitoninPeak,hsCRPPeak,interleukin6Peak,dDimerPeak,firstORF1abCt"
	ColstrL = "bloodHB,bloodWBC,bloodLymph,bloodPlatelet,bloodBUN,bloodCr,bloodAlbumin,enzymeSGOT,enzymeSGPT,procalcitoninPeak,hsCRPPeak,interleukin6Peak,dDimerPeak,firstORF1abCt".split(",")
	for i in ColstrL:
		nf(InDict,i)

	# lungCXR
	choiceL = "WNL,GGO,Consol,Mixed".split(",")
	choicer(InDict, "lungCXR", choiceL)

	# sumSeverity
	choiceL = "Asymp,Mild,Mod,Severe,Critical".split(",")
	choicer(InDict, "sumSeverity", choiceL)

	# "favi,remdes,dexaOrMP,pred,tocilizumab"
	ColstrL = "favi,remdes,dexaOrMP,pred,tocilizumab".split(",")
	for i in ColstrL:
		tf(InDict,i)

	# oxygen
	choiceL = "No,Can/col,HFNC,Respirator".split(",")
	choicer(InDict, "oxygen", choiceL)

	# dischargeDate
	dater(InDict,"dischargeDate")

	# dischargeType
	choiceL = "Recovery,Improved,Dead,Ongoin_treatment,Refer_out".split(",")
	dumb_choicer(InDict, "dischargeType", choiceL, 4)

	# Genomic # skip!
	p.press('tab')
	p.press('tab')
	#p.scroll(100) ## Scroll Up to top most To Check ID
	p.press('enter') ## Enter to Submit Form <------------------
	t.sleep(55)
	
	scrFname = "Scr_" + InDict['redcapId'] +"_"+ InDict['labCode']  + "_" + "-".join(str(datetime.now()).strip().split()) +".png"	
	p.screenshot(scrFname)
	t.sleep(33)
	print("Screenshot saved to",scrFname)
	p.press('esc')
	t.sleep(10)

CSVfname = sys.argv[1]
CSVdict = csv_to_dict(CSVfname)
p.press('f11')
for row in CSVdict:
	for key, value in row.items():
		print(key, "=" ,value)
	#print( datetime.fromtimestamp( int(row["dischargeDate"]), '%Y%m%d') )
	
	formFill(row)

t.sleep(11)
p.press('esc')
p.press('esc')
p.press('esc')
p.press('f11')


"""
p.click('BTN/addB.png')
t.sleep(2)
p.click('BTN/1stF.png')
t.sleep(1.8)
wtab("XXXBBBBB")
wtab("GBANKIDXXXX")
t.sleep(0.5)
wtab("LABIDXXXX")
wchoice(2)
wtab(75)
wchoice()
"""
