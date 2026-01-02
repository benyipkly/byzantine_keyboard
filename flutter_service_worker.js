'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "fc8d76e83100dd47cb7afdac03166343",
".git/config": "0d86bdbc155c37588b20f3e87b0e421c",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "8f55ae1093fff005735ee6a7f9d8f192",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "d37539399fef8781a7223616e5fb942f",
".git/logs/refs/heads/main": "d37539399fef8781a7223616e5fb942f",
".git/logs/refs/remotes/origin/gh-pages": "d8a17c59aadd81ee45f6467c5d4a58ce",
".git/objects/08/27c17254fd3959af211aaf91a82d3b9a804c2f": "360dc8df65dabbf4e7f858711c46cc09",
".git/objects/1e/ad45ee2682f286f8a879b46b79fa88cb31f2e9": "ab63e40bac72b916fd2ee71703249685",
".git/objects/20/ceb0c18ec8f10cb6a8a8de39849917170a6600": "4d0e90f906d78e09f0d976a9f0aa9b9b",
".git/objects/23/204c46b635be7629e66ad7dcc67a2a6f31dcf0": "ca19e46c44659df31ac70430c52429e6",
".git/objects/24/7f7c2ac57ac06e0c909535747055785a52b907": "268510770deda02dac3d8248f8498599",
".git/objects/28/cccde73438405e0b77b4f6d12b25411583174e": "3dd80e8fb90af46969f3cd96b253061e",
".git/objects/2d/52691f31aa784fb32ade694d0ca6d24c4dacec": "7baa737463a1145d035e88d63a050628",
".git/objects/38/29ce71e6abba6469fa08e6beea8ddebc9caeba": "ada3b0eae3cea49471e277f105a91b5f",
".git/objects/3a/8cda5335b4b2a108123194b84df133bac91b23": "1636ee51263ed072c69e4e3b8d14f339",
".git/objects/40/be05a88d2603408ec74333a88ad8da65d8921b": "9ba4927902fa2ed36741b60699b5827b",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/51/03e757c71f2abfd2269054a790f775ec61ffa4": "d437b77e41df8fcc0c0e99f143adc093",
".git/objects/57/664a02a132ba1e43f3c6661c720465a7dc519d": "c526d681844c182e944924ee85ec866c",
".git/objects/5d/2b497dc18eb999396b4571da9a6b7e2d4ed336": "d8af9e328d6c3b725de3602322fc6792",
".git/objects/68/43fddc6aef172d5576ecce56160b1c73bc0f85": "2a91c358adf65703ab820ee54e7aff37",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6f/7661bc79baa113f478e9a717e0c4959a3f3d27": "985be3a6935e9d31febd5205a9e04c4e",
".git/objects/78/b8e62bef9368c1ae09cf5a49a12d8a18f7bce9": "eb9558bcbd87a641de51c402f5edf8bd",
".git/objects/7c/3463b788d022128d17b29072564326f1fd8819": "37fee507a59e935fc85169a822943ba2",
".git/objects/85/63aed2175379d2e75ec05ec0373a302730b6ad": "997f96db42b2dde7c208b10d023a5a8e",
".git/objects/89/28cc70a9a39d22d1f3455b914fa593f711a990": "2f1d6568e80dca21cbe57aa7e14242db",
".git/objects/8d/019f6d6d21ed840e6fcb35b391768b4eed2571": "e20ca26c19af22f0b7ca88ead82cfb92",
".git/objects/8e/21753cdb204192a414b235db41da6a8446c8b4": "1e467e19cabb5d3d38b8fe200c37479e",
".git/objects/93/b363f37b4951e6c5b9e1932ed169c9928b1e90": "c8d74fb3083c0dc39be8cff78a1d4dd5",
".git/objects/93/f8c1d1720f8fc79a2cf44f02c7ff38636bee8f": "bfc77775e9b1f91fa6bc0be0c4eeeec3",
".git/objects/a7/3f4b23dde68ce5a05ce4c658ccd690c7f707ec": "ee275830276a88bac752feff80ed6470",
".git/objects/a7/85b960002bb207a0cbdf2966f433b6ea7ac1ab": "713c72fa8d3e8ccb2015528ac5eb1bcd",
".git/objects/ac/ae08cb39e4e6be60de1add31729218768c6d2a": "912408db876a85416dbc7b839e51ef55",
".git/objects/ad/ced61befd6b9d30829511317b07b72e66918a1": "37e7fcca73f0b6930673b256fac467ae",
".git/objects/ae/9c13d692193cbd0106b00953c4ce83d95c0b5f": "5f4bbf6dc5c9fa5bd80d2f7cce1368a5",
".git/objects/b6/fa78186a8401929f5a3aa41f58e7ad5fc48b19": "39e375d818a656cf2476d66adf58e2ef",
".git/objects/b9/3e39bd49dfaf9e225bb598cd9644f833badd9a": "666b0d595ebbcc37f0c7b61220c18864",
".git/objects/c8/3af99da428c63c1f82efdcd11c8d5297bddb04": "144ef6d9a8ff9a753d6e3b9573d5242f",
".git/objects/cd/3b8594e19a935c3cc802a64ba3876536b56a2d": "3fd6a6794d4dbd9402ae1c87d1f36cf5",
".git/objects/d1/8db55ecbe2df5eac536abe1ffb720b7a699819": "f15e49b750c88927f35e46e6ce474806",
".git/objects/d2/e3fe38b69cd0e4cec07098b2653e9856269746": "5e7d68388305e42e0f5ff2b12f56415d",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d5/3e177a9246090202d39992e95b424bbedc5469": "f27037aabe9528a6c34b4a58c9dd070a",
".git/objects/d9/5b1d3499b3b3d3989fa2a461151ba2abd92a07": "a072a09ac2efe43c8d49b7356317e52e",
".git/objects/dd/fd419685ab9dc41c42c4627736d1799ba9a71f": "aba1be8e89361a941b0c3507300de177",
".git/objects/de/25ca9b4e526478cd9e16c06fc109aac36d4ef6": "e71dfbf703e6a25a5e5e5c1790b5bb73",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ee/fddde9d85922c2f9a014bd3b5664c9a690c644": "e51b083b06d62d1918f243c312e5c8c8",
".git/objects/f3/3e0726c3581f96c51f862cf61120af36599a32": "afcaefd94c5f13d3da610e0defa27e50",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f6/e6c75d6f1151eeb165a90f04b4d99effa41e83": "95ea83d65d44e4c524c6d51286406ac8",
".git/objects/fb/15edf3ba5c55759194f6d9b02c6dd792944709": "df0123ff0a667275ae64fe2904195355",
".git/objects/fb/5759182dfb01fe89596ead9c85dbe124c3b586": "73520b06362a01dddfe7209a99d68003",
".git/objects/fd/05cfbc927a4fedcbe4d6d4b62e2c1ed8918f26": "5675c69555d005a1a244cc8ba90a402c",
".git/refs/heads/main": "af3ad71895163f612a2facb603a2f3b8",
".git/refs/remotes/origin/gh-pages": "af3ad71895163f612a2facb603a2f3b8",
"assets/AssetManifest.bin": "7adedbe85c263d4bd4d9c71c1e0f5612",
"assets/AssetManifest.bin.json": "6b3dbe1a29d8dfa20ee29e2b46a8da26",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "ab6ba692d784b79f8889367bdfab69c5",
"assets/NOTICES": "e376fd8ddcb973deec620ae51ac58529",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_soloud/web/init_module.dart.js": "ea0b343660fd4dace81cfdc2910d14e6",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.js": "7125e998b52325a0c79804c133b3492c",
"assets/packages/flutter_soloud/web/libflutter_soloud_plugin.wasm": "e16d81271adabfafc4ec0a85e7579ae0",
"assets/packages/flutter_soloud/web/worker.dart.js": "2fddc14058b5cc9ad8ba3a15749f9aef",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"coi-serviceworker.js": "ca2d4225722739a46868887ae2f607e8",
"favicon.png": "2f653934ce962411c5b56ad0f57931ff",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "a222326f175d625d01c693a7cb49f7a8",
"icons/Icon-192.png": "6ee06abbf183215ef03225c4b9828638",
"icons/Icon-512.png": "a856bf37a99b4ce9a2c2109c51158015",
"icons/Icon-maskable-192.png": "6ee06abbf183215ef03225c4b9828638",
"icons/Icon-maskable-512.png": "a856bf37a99b4ce9a2c2109c51158015",
"index.html": "4bca3ea3b1c0b90068566e86e23398cc",
"/": "4bca3ea3b1c0b90068566e86e23398cc",
"main.dart.js": "90bae722df491dbc499fc21df56fc55d",
"manifest.json": "9f9c71f896fa0d0459683db612ef68a3",
"version.json": "298d94933119b8e2b4c27474ad2b43b8"};
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
