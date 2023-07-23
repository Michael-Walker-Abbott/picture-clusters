using Random
using Statistics

# Function to calculate Euclidean distance between two points
function euclidean_distance(x, y)
    return sqrt(sum((x .- y).^2))
end

# K-means clustering function
function kmeans(data, k, max_iter=100)
    n, d = size(data)
    centroids = data[shuffle(1:n)[1:k], :]
    clusters = zeros(Int, n)
    total_square_distances = Inf
    
    for iter in 1:max_iter
        println("iteration ", iter)
        println("distance: ", total_square_distances)
        # Assign points to the nearest centroid
        total_square_distances = 0
        for i in 1:n
            min_distance = Inf
            for j in 1:k
                distance = euclidean_distance(data[i, :], centroids[j, :])
                if distance < min_distance
                    clusters[i] = j
                    min_distance = distance
                end
            end
            total_square_distances += min_distance^2
        end
        
        
        for j in 1:k
            cluster_points = data[clusters .== j, :]
            centroids[j, :] = mean(cluster_points, dims=1)
        end
    end
    
    return centroids, clusters
end


using Images
# Load the image

img = load("pictures/scream.jpeg")


rows,columns = size(img)
num_of_pixels = rows*columns

Labimg = convert.(Lab,img)
pixel_vector = transpose(reshape(channelview(Labimg),3,num_of_pixels))
ab_values_vector = pixel_vector[:,2:3]

k = 4
centroids, clusters = kmeans(ab_values_vector,k, 15)

new_images = zeros(k,num_of_pixels,3)

for i in 1:num_of_pixels
    new_images[clusters[i],i,:] = pixel_vector[i,:]
end

display(img)
for i in 1:k
    display(colorview(Lab,reshape(transpose(new_images[i,:,:]),3,rows,columns)))
end

pixel_vector[2]


img[400,200]