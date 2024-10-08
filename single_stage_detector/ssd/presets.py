import transforms as T
import time
import datetime


class DetectionPresetTrain:
    def __init__(self, data_augmentation, hflip_prob=0.5, mean=(123., 117., 104.)):
        print("bitchebe: DetectionPresetTrain")
        start_time = time.time()
        if data_augmentation == 'hflip':            
            print("bitchebe: hflip transformations start")
            self.transforms = T.Compose([
                T.RandomHorizontalFlip(p=hflip_prob),
                T.ToTensor(),
            ])            
            total_time = start_time - time.time()
            total_time_str = str(datetime.timedelta(seconds=int(total_time)))
            print('bitchebe: hflip transformations time {}'.format(total_time_str))
        elif data_augmentation == 'ssd':
            print("bitchebe: ssd transformations start")
            self.transforms = T.Compose([
                T.RandomPhotometricDistort(),
                T.RandomZoomOut(fill=list(mean)),
                T.RandomIoUCrop(),
                T.RandomHorizontalFlip(p=hflip_prob),
                T.ToTensor(),
            ])
            total_time = start_time - time.time()
            total_time_str = str(datetime.timedelta(seconds=int(total_time)))
            print('bitchebe: ssd transformations time {}'.format(total_time_str))
        elif data_augmentation == 'ssdlite':
            print("bitchebe: ssdlite transformations start")
            self.transforms = T.Compose([
                T.RandomIoUCrop(),
                T.RandomHorizontalFlip(p=hflip_prob),
                T.ToTensor(),
            ])
            total_time = start_time - time.time()
            total_time_str = str(datetime.timedelta(seconds=int(total_time)))
            print('bitchebe: ssdlite transformations time {}'.format(total_time_str))
        else:
            raise ValueError(f'Unknown data augmentation policy "{data_augmentation}"')

    def __call__(self, img, target):
        return self.transforms(img, target)


class DetectionPresetEval:
    def __init__(self):
        self.transforms = T.ToTensor()

    def __call__(self, img, target):
        return self.transforms(img, target)

