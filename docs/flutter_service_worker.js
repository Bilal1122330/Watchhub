'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".vscode/settings.json": "19751b2a32e46d1ba1477f357123a898",
"assets/AssetManifest.bin": "834369fd98cd96118d829360857d9a4c",
"assets/AssetManifest.bin.json": "381d2e9803aada48d100c4c65a104a14",
"assets/AssetManifest.json": "744f21aaa44d75942752dd13423f6889",
"assets/assets/fonts/Nunito-Regular.ttf": "b83ce9c59c73ade26bb7871143fd76bb",
"assets/assets/media/avator/avator.jpg": "109df47056e20538ab805d228b16aa86",
"assets/assets/media/avator/user1.jpg": "f6b15f59b07f1cea7b15ae0f099ae436",
"assets/assets/media/avator/user2.png": "f409968508da7133d1098f11c6562b1c",
"assets/assets/media/avator/watch.png": "237eef578261e73a391f5e79493e9b5e",
"assets/assets/media/avator/watch3.jpg": "4a18df272cbd81d75a6dc7603c4ae89c",
"assets/assets/media/avator/watchpic1.jpg": "2b67679016265f017901b86a060f4811",
"assets/assets/media/avator/watchpic2.jpg": "52995a8f08747338460db1189fd0418a",
"assets/assets/media/avator/watchpic3.jpg": "7a51b38bb08ce4815bf695d39b153ca6",
"assets/assets/media/avator/watchpic4.jpg": "c925e4f6fe0b46a8235e2cdb08059725",
"assets/assets/media/avator/watchpic5.jpg": "99f9527096fe25200c0da62f78f33639",
"assets/assets/media/avator/watchpic6.jpg": "3d845a15acbc7c4316730a554e9e9098",
"assets/assets/media/back_video/angel.mp4": "6d2cf7e2d438ae85cadb8be76f35bdfb",
"assets/assets/media/back_video/bg.mp4": "7b498c932a5248f89cf2b18779fe94a1",
"assets/assets/media/back_video/couple_1.mp4": "26a9a7c5522547e1e5f837a4b527506d",
"assets/assets/media/back_video/pheonix3.mp4": "57e37c19cc9938b1deea95e7bcfaa8c2",
"assets/assets/media/back_video/videoplayback.mp4": "fc9184a3919b6b9dcaa5966f56aaff29",
"assets/assets/media/back_video/videoplayback1.mp4": "8d5a30308b4e28957f0d7ac0791915d7",
"assets/assets/media/back_video/watch1.mp4": "7d66748be01edf792e52483d7aab3452",
"assets/assets/media/back_video/watch2.mp4": "98ab383093ee4c2aa4f464d67c04167d",
"assets/assets/media/back_video/watch3.mp4": "98ab383093ee4c2aa4f464d67c04167d",
"assets/assets/media/banner/drawer.jpg": "7af027b154da54ce37a2c434b8906464",
"assets/FontManifest.json": "7c8eb5d4369066d36d8050154c1af682",
"assets/fonts/MaterialIcons-Regular.otf": "06a88f60d5283e15ee6ae6da40b9af3d",
"assets/NOTICES": "8f7bb36032fd80259358011a59ad9c3f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "3281fcbfe0e70fa87229a9f988618b94",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "bffe5d6a137118abc2c0a637e3298488",
"icons/Icon-192.png": "114260bcb500f70fefa840272446e0b4",
"icons/Icon-512.png": "d903124b9e9eb4f84290de3130875b81",
"icons/Icon-maskable-192.png": "114260bcb500f70fefa840272446e0b4",
"icons/Icon-maskable-512.png": "d903124b9e9eb4f84290de3130875b81",
"index.html": "d5daad0812d3bef7e36fce1f4674d418",
"/": "d5daad0812d3bef7e36fce1f4674d418",
"main.dart.js": "30b5f489fa1366d47c8e2adcd4ad5eca",
"manifest.json": "cdc4041595da1fbde33a70b222c3f349",
"version.json": "eb83aae084fc2df5653f9a3534194957"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
