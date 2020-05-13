import coremltools

# create a var caffe_model = (model, architecture description)
caffe_model = ('oxford102.caffemodel', 'deploy.prototxt')

# create a var for label file containing names of classes
labels = 'flower-labels.txt'

# create var to store outputs of conversion method
coreml_model = coremltools.converters.caffe.convert(
    # list all parameters here (names in documentation)
    caffe_model,
    class_labels=labels,
    image_input_names='data'
    #check input name from other file
)

# save var in coreML file with name and extension 'FlowerClassifier.mlmodel'
coreml_model.save('FlowerClassifier.mlmodel')

# CHECK SPELLING TO MAKE SURE EXACT AS file
