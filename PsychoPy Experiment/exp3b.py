import time, os.path
from psychopy import prefs
prefs.general['audioLib'] = ['pygame']
from psychopy import visual, sound, core, event, gui
import numpy as np
import csv
from scipy.special import comb
import numpy

#dialogue box to set participant ID
#info = {'Participant ID':''}
#dictDlg = gui.DlgFromDict(dictionary=info,
#          title='TestExperiment', fixed=['ExpVersion'])
#if dictDlg.OK:
#   print(info)
#   participant=info['Participant ID']
#else:
#   print('User Cancelled')
#   core.quit()


participant='1'
#check whether logfile already exists; warning dialogue box if so
filename='Logfiles/p_'+participant+'_logfile.csv'
#if os.path.isfile(filename):
#   warningbox=gui.Dlg(title="Warning")
#   warningbox.addText('A logfile already exists for this participant ID. \
#   Do you want to overwrite it?')
#   overwrite=warningbox.show()
#   if not warningbox.OK:
#          core.quit()

#create logfile; write timestamp, experiment info, and data headers
datafile=open(filename,'w')
datafile.write(time.strftime('%d-%b-%Y %H:%M:%S')+'\nSound experiment logfile\n\
Participant '+participant+'\n\nsound1,sound2,response\n')
datafile.close()

expwin=visual.Window(fullscr=True,allowGUI=False)
textstim=visual.TextStim(expwin,color='black',text=' ',pos=(0.0,0.0))
keymsg=visual.TextStim(expwin,color='black',text=' ',pos=(0.0,0.0))
stim=visual.ImageStim(expwin,image=None,units='pix')


#get the file with the stimuli and make them into a dictionary
with open('da_ta_all.csv','r') as inputfile:
     triallist=csv.DictReader(inputfile)
     trials=[]
     for row in triallist:
         trials.append(row)


#get the file with the images and make them into a dictionary
with open('Images/images.csv','rb') as inputfile:
     imagelist=csv.DictReader(inputfile)
     images=[]
     for row in imagelist:
         images.append(row)

with open('Sounds/sounds.csv','rb') as inputfile:
     soundlist=csv.DictReader(inputfile)
     asmr=[]
     for row in soundlist:
         asmr.append(row)

#make all combinations of stimuli
trial_no=np.arange(13)

pairs_click=[]
pairs_wn = []
i=1
while i<=35:
      if i<=7 or 20<=i<=26:
         pairs_click=np.append(pairs_click,[i,i+1])
         pairs_click=np.append(pairs_click,[i,i+2])
         pairs_click=np.append(pairs_click,[i+1,i+2])
      if 10<=i<=16 or 29<=i<=35:
         pairs_wn=np.append(pairs_wn,[i,i+1])
         pairs_wn=np.append(pairs_wn,[i,i+2])
         pairs_wn=np.append(pairs_wn,[i+1,i+2])
      if i==16:
         i=i+4
      else:
         i=i+3

#arraymix=np.array([1,4,7])

#while max(arraymix)<=38:
#      if max(arraymix)<=9 or 26<=max(arraymix)<=28:
#         pairs_click=np.append(pairs_click,[arraymix[0],arraymix[1]])
#         pairs_click=np.append(pairs_click,[arraymix[0],arraymix[2]])
#         pairs_click=np.append(pairs_click,[arraymix[1],arraymix[2]])
#      if 16<=max(arraymix)<=18 or 35<=max(arraymix)<=38:
#         pairs_wn=np.append(pairs_wn,[arraymix[0],arraymix[1]])
#         pairs_wn=np.append(pairs_wn,[arraymix[0],arraymix[2]])
#         pairs_wn=np.append(pairs_wn,[arraymix[1],arraymix[2]])
#      if max(arraymix)==9 or max(arraymix)==28:
#         arraymix=arraymix+7
#      else:
#         arraymix=arraymix+1

for i in range(1,19):
    if i<=9:
       pairs_click=np.append(pairs_click,[i,19])
    else:
       pairs_wn=np.append(pairs_wn,[i,19])

for i in range(20,38):
    if i<=28:
       pairs_click=np.append(pairs_click,[i,38])
    else:
       pairs_wn=np.append(pairs_wn,[i,38])

pairs_click=numpy.reshape(pairs_click,(len(pairs_click)/2,2))
pairs_click_counter=np.fliplr(pairs_click)
block_click = np.concatenate((pairs_click, pairs_click_counter))

pairs_wn=numpy.reshape(pairs_wn,(len(pairs_wn)/2,2))
pairs_wn_counter=np.fliplr(pairs_wn)
block_wn = np.concatenate((pairs_wn, pairs_wn_counter))

pairs_combined=np.array([1,10,2,11,3,12,20,29,21,30,22,31])
pairs_combined=numpy.reshape(pairs_combined,(len(pairs_combined)/2,2))
pairscombrev=np.fliplr(pairs_combined)
block_combined=np.concatenate((pairs_combined,pairscombrev))
block_combined=np.tile(block_combined,5)
#maybe have a make_block function, include repetitions


np.random.shuffle(block_combined)

[a,b]=np.shape(block_combined)
block_combined=numpy.reshape(block_combined,a*b)

def make_stim(block,trials):
    auds=[]
    des=[]
    for i in range (len(block)):
        trial=trials[int(block[i])-1]
        auds.append(sound.Sound(trial['Stimulus']))
        des.append(trial['Description'])
    return auds,des


auds3,des3=make_stim(block_combined,trials)

def introduction():
    textstim.text='In the present experiment, two syllables DA and TA \
(chained into DADADADADA or TATATATATA) have been modified to contain different types of noise,\
at different intensity levels.\n\nYou will be presented with pairs of stimuli and asked to judge in which \
stimulus the added noise is more noticeable. Press 1 if the added noise is more noticeable in the first stimulus in the pair,\
or 2 - in the second stimulus.\n\nPress Enter to continue to the first block.'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()

def block1_instructions():
    textstim.text='This block will be divided into five parts, each lasting approximately 5 minutes, with breaks in between.\
\n\nIn this block, the added noise will sound like a click. An amplified version of the click will be presented twice now.\
\n\nPress Enter to play the added noise.'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()

def block1():
    textstim.text='BLOCK 1/3'
    textstim.draw()
    expwin.flip()
    core.wait(1)

def block2():
    textstim.text='BLOCK 2/3'
    textstim.pos=[0,0]
    textstim.draw()
    expwin.flip()
    core.wait(1)

def block3():
    textstim.text='BLOCK 3/3'
    textstim.pos=[0,0]
    textstim.draw()
    expwin.flip()
    core.wait(1)

def end_block1():
    textstim.text='End of Block 1/3'
    textstim.pos= [0,0.7]
    textstim.draw()
    pic=images[4]
    stim.setImage(pic['files'])
    stim.draw()
    expwin.flip()
    core.wait(3)

def end_block2():
    textstim.text='End of Block 2/3'
    textstim.pos=[0,0.7]
    textstim.draw()
    pic=images[9]
    stim.setImage(pic['files'])
    stim.draw()
    expwin.flip()
    core.wait(3)

def end_of_experiment():
    textstim.text='End of the experiment. Well done!'
    textstim.pos=[0,0.7]
    textstim.draw()
    pic=images[10]
    stim.setImage(pic['files'])
    stim.draw()
    expwin.flip()
    core.wait(3)

def block2_instructions():
    textstim.text='Block 2 will also be divided into five parts of the same durations as before, with breaks in between.\
\n\nThe added noise here will sound like hissing. An amplified version of the noise will be played twice now.\
\n\nPress Enter to play the added noise.'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()

def block3_instructions():
    textstim.text='The final block will last approximately 2 minutes.\
\n\nHere, you will be presented with pairs of sounds\
containing the two different types of added noise.\
\n\nAfter each trial, you will be asked which stimulus contained the more noticeable noise.\
\n\nPress Enter to continue to the last block.'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()
                 
#def play_da(sound):
#    textstim.text='Da'
#    textstim.draw()
#    expwin.flip()
#    sound.play()
#    core.wait(1.25)
    
#def play_wn(sound):
#    textstim.text='Ta'
#    textstim.draw()
#    expwin.flip()
#    sound.play()
#    core.wait(1.25)

def inter_trial():
    textstim.text='*'
    textstim.draw()
    expwin.flip()
    if len(event.getKeys())>0:
       continueRoutine=True
    core.wait(0.5)

def play_trial_one(sound):
    textstim.text='1'
    textstim.draw()
    expwin.flip()
    sound.play()
    core.wait(1.25)

def play_trial_two(sound):
    textstim.text='2'
    textstim.draw()
    expwin.flip()
    sound.play()
    core.wait(1.25)
    
   
def keyboard_trial():
    textstim.text='Where was the added noise more noticeable?\nPress 1 or 2.'
    textstim.draw()
    expwin.flip()
    sol=''
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['1']:
                 sol+=str(key)
                 responsecomplete=True
              if key in ['2']:
                 sol+=str(key)
                 responsecomplete=True
              elif key in ['escape']:
                   expwin.close()
                   core.quit()
                   event.clearEvents()
    return sol

def play_block(sound,des):
    i=0
    while i<len(sound)-1:
        play_trial_one(sound[i])
        if len(event.getKeys())>0:
           continueRoutine=True
        inter_trial()
        play_trial_two(sound[i+1])
        if len(event.getKeys())>0:
           continueRoutine=True
        core.wait(0.5)
        ans=keyboard_trial()
        logtrial(des[i],des[i+1],ans)
        inter_trial()
        i=i+2

def logtrial(des1,des2,response):
    datafile=open(filename,'a')
    datafile.write(str(des1)+','+\
str(des2)+','+str(response)+'\n')
    datafile.close()

def break_window(pic,sound):
    stim.setImage(pic)
    stim.draw()
    expwin.flip()
    sound.play()
    core.wait(20)
    textstim.text='Press Enter to continue'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()

def continue_window():
    textstim.text='Press Enter to continue'
    textstim.draw()
    expwin.flip()
    responsecomplete=False
    while not responsecomplete:
          for key in event.getKeys():
              if key in ['return']:
                 responsecomplete=True
              elif key in ['escape']:
                 expwin.close()
                 core.quit()
                 event.clearEvents()

#da_alone = trials[12]

#da = []
#da.append(sound.Sound(da_alone['Stimulus']))

#ta_alone = trials[25]

#ta = []
#ta.append(sound.Sound(ta_alone['Stimulus']))

click=sound.Sound('click.wav')
whitenoise=sound.Sound('whitenoise.wav')

introduction()
block1()
block1_instructions
textstim.text='Click'
textstim.draw()
expwin.flip()
click.play()
core.wait(1)
inter_trial()
textstim.text='And again'
textstim.draw()
expwin.flip()
core.wait(1)
textstim.text='Click'
textstim.draw()
expwin.flip()
click.play()
core.wait(1)
continue_window()
for i in range(5):
    np.random.shuffle(block_click)
    block_click_shuff=numpy.reshape(block_click,len(block_click)*2)
    auds1,des1=make_stim(block_click_shuff,trials)
    play_block(auds1,des1)
    if i<4:
       pic=images[i]
       music=asmr[i]
       m=sound.Sound(music['files'])
       break_window(pic['files'],m)
end_block1()
block2()
block2_instructions()
block1_instructions
textstim.text='Hissing Sound'
textstim.draw()
expwin.flip()
whitenoise.play()
core.wait(1)
inter_trial()
textstim.text='And again'
textstim.draw()
expwin.flip()
core.wait(1)
textstim.text='Hissing Sound'
textstim.draw()
expwin.flip()
whitenoise.play()
core.wait(1)
continue_window()
for i in range(5):
    p.random.shuffle(block_wn)
    block_wn_shuff=numpy.reshape(block_wn,len(block_wn)*2)
    auds2,des2=make_stim(block_wn_shuff,trials)
    play_block(auds2,des2)
    if i<4:
       pic=images[i+5]
       music=asmr[i+4]
       m=sound.Sound(music['files'])
       break_window(pic['files'],m)
end_block2()
block3()
block3_instructions()
play_block(auds3,des3)
end_of_experiment()

expwin.close()
core.quit()

    
    

  

 

 

 

