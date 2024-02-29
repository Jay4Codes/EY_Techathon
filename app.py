# Importing necessary libraries and mounting personal google drive to feed the texture images
import streamlit as st
from streamlit_custom_notification_box import custom_notification_box
from streamlit_option_menu import option_menu
from docarray import Document, DocumentArray
import torchvision
from streamlit_image_comparison import image_comparison
import streamlit.components.v1 as components
from PIL import Image
from streamlit_cropper import st_cropper
import numpy as np
import os
from sklearn.metrics.pairwise import cosine_similarity
import matplotlib.pyplot as plt
from transformers import ViTFeatureExtractor, ViTModel
import torch

if torch.cuda.is_available():
    device = "cuda"
else:
    device = "cpu"

model_name = "google/vit-large-patch16-224-in21k"
feature_extractor = ViTFeatureExtractor(model_name)
model = ViTModel.from_pretrained(model_name)

# input_dir = 'mydata'
# resized_imgs_dir = './frontend/public/resized_images/'

# def calc_embeddings(img_dir):
#   embedding_vectors = []

#   for filename in os.listdir(img_dir):
#       image_path = os.path.join(img_dir, filename)
#       image = Image.open(image_path)

#       inputs = feature_extractor(images=image, return_tensors="pt")

#       with torch.no_grad():
#           output = model(**inputs)

#       embedding_vector = output.last_hidden_state.mean(dim=1)
#       embedding_vectors.append(embedding_vector)

#   return torch.stack(embedding_vectors)

# resized_imgs_embeddings_tensors = calc_embeddings(resized_imgs_dir)
imageUrls = []

# def query_similar_imgs(embedding_tensors):
#   num_images, num_embeddings, embedding_dims = embedding_tensors.shape
#   embedding_tensors_2d = embedding_tensors.reshape(num_images, -1)
#   similarity_matrix = cosine_similarity(embedding_tensors_2d)
#   similarity_scores = similarity_matrix[2]
#   similar_textures = [(i, score) for i, score in enumerate(similarity_scores) if i != 2]
#   similar_textures.sort(key=lambda x: x[1], reverse=True)
#   top_similar_textures = similar_textures[:4]
#   os.path.join(resized_imgs_dir, os.listdir(resized_imgs_dir)[2])

#   for i, (texture_index, score) in enumerate(top_similar_textures):
#       imageUrls.append(os.path.join(resized_imgs_dir, os.listdir(resized_imgs_dir)[texture_index]))

# query_similar_imgs(resized_imgs_embeddings_tensors)

# print(imageUrls)

with st.sidebar:
    selected = option_menu(None, ["Home", "Product Similarity", "Voice Clonning", "Lip Synchronization", "Translate"],
                        icons=['house'], menu_icon="cast", default_index=0)

    styles = {'material-icons': {'color': 'red'},
            'text-icon-link-close-container': {'box-shadow': '#3896de 0px 4px'},
            'notification-text': {'': ''},
            'close-button': {'': ''},
            'link': {'': ''}}

if selected == "Home":

    st.title('EY Techathon')

    img_file = st.file_uploader(label='Upload a file', type=['png', 'jpg'])
    realtime_update = st.checkbox(label="Update in Real Time", value=True)
    box_color = st.color_picker(label="Box Color", value='#0000FF')
    aspect_choice = st.radio(label="Aspect Ratio", options=[
        "1:1", "16:9", "4:3", "2:3", "Free"])
    aspect_dict = {
        "1:1": (1, 1),
        "16:9": (16, 9),
        "4:3": (4, 3),
        "2:3": (2, 3),
        "Free": None
    }
    aspect_ratio = aspect_dict[aspect_choice]

    if img_file:
        img = Image.open(img_file)
        if not realtime_update:
            st.write("Double click to save crop")

        cropped_img = st_cropper(img, realtime_update=realtime_update, box_color=box_color,
                                aspect_ratio=aspect_ratio)

        st.write("Preview")
        _ = cropped_img.thumbnail((150, 150))
        st.image(cropped_img)

    imageCarouselComponent = components.declare_component(
        "image-carousel-component", path="./frontend/public")

    selectedImageUrl = imageCarouselComponent(imageUrls=imageUrls, height=200)

    if selectedImageUrl is not None:
        st.image(selectedImageUrl)

