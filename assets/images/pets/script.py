from PIL import Image
from pathlib import Path
from typing import cast
import numpy as np
import os


if __name__ == "__main__":
    for file in os.listdir("."):
        # continue if the file is not an image
        if not file.endswith(".png"):
            continue
        
        path = Path(os.path.join(".", file))
        with Image.open(path) as image:
            image.load()
            image = image.convert("RGBA")
            matrix = np.array(image).astype(np.int16)
            
            # for BGRA image
            r, g, b, a = matrix[:, :, 0], matrix[:, :, 1], matrix[:, :, 2], matrix[:, :, 3] 
            
            vertical_means = np.mean(a, axis=0)
            horizontal_means = np.mean(a, axis=1)
            
            left = 0
            while left < len(vertical_means):
                if vertical_means[left] > 0:
                    break
                left += 1
            
            right = len(vertical_means) - 1
            while right >= 0:
                if vertical_means[right] > 0:
                    break
                right -= 1
                
            top = 0
            while top < len(horizontal_means):
                if horizontal_means[top] > 0:
                    break
                top += 1
                
            bottom = len(horizontal_means) - 1
            while bottom >= 0:
                if horizontal_means[bottom] > 0:
                    break
                bottom -= 1
            
            # create output directory if not exists.
            if not os.path.exists("./output"):
                os.makedirs("./output")

            trimmed = image.crop((left, top, right, bottom))
            trimmed.save(os.path.join("./output", path.name))
        
        print(path.name)