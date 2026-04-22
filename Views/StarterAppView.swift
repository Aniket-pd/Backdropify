import SwiftUI

struct StarterAppView: View {
    var body: some View {
        TabView {
            StarterBrowseView()
                .tabItem {
                    Label("Browse", systemImage: "photo.on.rectangle.angled")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

private struct StarterBrowseView: View {
    @StateObject private var collectionsViewModel = WallpaperCollectionsViewModel()

    var body: some View {
        NavigationStack {
            List {
                if collectionsViewModel.collections.isEmpty {
                    Section("Collections") {
                        ProgressView("Loading collections...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    Section("Collections") {
                        ForEach(Array(collectionsViewModel.collections.enumerated()), id: \.offset) { _, collection in
                            NavigationLink {
                                CollectionDetailView(collection: collection)
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: collection.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.2))
                                    }
                                    .frame(width: 54, height: 54)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(collection.name)
                                            .font(.headline)
                                        Text("Open collection")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Backdropify Starter")
            .toolbar {
                Button("Refresh") {
                    collectionsViewModel.fetchCollections()
                }
            }
            .onAppear {
                collectionsViewModel.fetchCollections()
            }
        }
    }
}

#Preview {
    StarterAppView()
}
