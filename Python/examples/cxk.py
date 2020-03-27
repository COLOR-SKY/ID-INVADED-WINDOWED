import sys
import cv2
import os
import numpy as np
from dancywindow import *

dir_path = r'D:/openpose/build'
sys.path.append(dir_path + '/python/openpose/Release')
os.environ['PATH'] = os.environ['PATH'] + ';' + dir_path + '/x64/Release;' + dir_path + '/bin;'

import pyopenpose as op

params = dict()
params["model_folder"] = "../../../models/"
# params["face"] = True
# params["hand"] = True

# Starting OpenPose
opWrapper = op.WrapperPython()
opWrapper.configure(params)
opWrapper.start()



cap = cv2.VideoCapture('./assets/cxk.mp4')
# cap = cv2.VideoCapture(0)

body_parts = ["nose", "neck"] + [d + p for d in ["r", "l"] for p in ["shoulder", "elbow", "wrist"]] + \
             [d + p for d in ["r", "l"] for p in ["hip", "knee", "ankle"]] + ["reye", "leye", "rear", "lear"]

body_windows = [AnimatedSketchWindow(
    name=name,
    x=-1,
    y=-1,
    w=130,
    h=130,
) for name in body_parts]


def draw_kunkun(poseKeypoints, image):
    if poseKeypoints.shape != (1, 25, 3):
        # for window in body_windows:
        #     window.destroy()
        return
    positions = poseKeypoints[0]
    positions = np.delete(positions, 2, 1)
    for i,window in enumerate(body_windows):
        if any(positions[i]) and i in [0, 1, 3, 4, 6, 7, 9, 10, 12, 13]:
            mask = ImageMask(image=image)
            window.set_position(winsize[0] / 2 - image.shape[1] / 2 + positions[i][0],
                                         winsize[1] / 2 - image.shape[0] / 2 + positions[i][1])
            window.mask_img(mask)
            window.draw()
        # else:
        #     window.destroy()

while True:
    ret, frame = cap.read()
    datum = op.Datum()
    try:
        datum.cvInputData = frame
    except TypeError:
        cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
    opWrapper.emplaceAndPop([datum])

    # Display Image
    out = datum.cvOutputData
    draw_kunkun(datum.poseKeypoints, frame)
    cv2.waitKey(1)
