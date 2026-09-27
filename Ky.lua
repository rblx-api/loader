-- deobf by 6.5mz
-- engine: hard lift / luarmor

-- reconstructed from static lift (luarmor)
-- VM bytecode is not re-executed. Strings, URLs, remotes and UI names were recovered from the protected blob.
-- script_key is stubbed so key-check branches do not crash a later run.
local script_key = script_key or getgenv and getgenv().script_key or ''
local genv = (getgenv and getgenv()) or _G

local recovered = {
  urls = {
    "https:--luarmor.net",
    "https:--media.discordapp.net/attachments/973020490530689094/1030611589302333481/lth.png",
    "https:--fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap",
  },
  webhooks = {
  },
  keys = {
  },
  ui = {
    "window.open('https:--docs.luarmor.net/', '_blank')",
    "window.location='https:--luarmor.net/login'",
    "window.open('https:--discord.gg/luarmor', '_blank')",
    "window.open('https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q', '_blank')",
    "window.location='#prices'",
    "window.open('https:--luarmor.net/login', '_blank')",
    "window.open('https:--luarmor.net/signup', '_blank')",
    "window.open('https:--docs.luarmor.net/', '_blank'); toggleMobileMenu();",
    "window.location='https:--luarmor.net/login'; toggleMobileMenu();",
    "window.open('https:--discord.gg/luarmor', '_blank'); toggleMobileMenu();",
    "window.open('https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q', '_blank'); toggleMobileMenu();",
    "window.location='#prices'; toggleMobileMenu();",
    "ll Love\n                </h2>\n                <p class=\"heroDescription\">\n                    Everything you need to manage your scripts and users automatically.\n                </p>\n            </div>\n            <div class=\"serviceCards\">\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/discordbotgif.gif\" alt=\"Discord Bot Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ð¤</div>\n                            <h3>Discord Bot</h3>\n                        </div>\n                        <p>Luarmor comes with a ready-to-use discord bot with a mini control panel for your users where\n                            they can redeem keys, reset HWID and more. Click to read more.</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/gen.gif\" alt=\"Key Stocking Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ð</div>\n                            <h3>Key Stocking</h3>\n                        </div>\n                        <p>You can mass generate day-locked or lifetime keys & export them to list them on your sellix /\n                            shoppy or whatever platform you are using.</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/runtimevar.png\" alt=\"Runtime Vars Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ð</div>\n                            <h3>Runtime Variables</h3>\n                        </div>\n                        <p>Runtime variables allow you to access key-specific data such as discord id, note, expiry date\n                            and more. Allowing you to add custom logic for specific users.</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/killswitch.gif\" alt=\"Killswitch Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ð</div>\n                            <h3>One Click Kill Switch</h3>\n                        </div>\n                        <p>You can disable, delete, update your scripts anytime you want, and it will immediately take\n                            effect for future executions.</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/locker.gif\" alt=\"Encrypted Backups Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ð</div>\n                            <h3>Encrypted Backups</h3>\n                        </div>\n                        <p>Luarmor gives you the option to encrypt & store your code just in case you ever lose access\n                            to source, or want to revert to an old version of your script. [read more].</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/adsys.gif\" alt=\"Ad System Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ðµ</div>\n                            <h3>Ad Key System</h3>\n                        </div>\n                        <p>Luarmor has a built-in, compatible and customizable ad link system with an effective\n                            anti-bypass, protecting your revenue and making everything easier.</p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    ")\">\n                    <div class=\"cardGif\">\n                        <img src=\"./newlanding/keyapi.png\" alt=\"Key Check API Demo\">\n                    </div>\n                    <div class=\"cardContent\">\n                        <div class=\"cardHeader\">\n                            <div class=\"iconCircle\">ðï¸</div>\n                            <h3>Key Check API</h3>\n                        </div>\n                        <p>We have a Lua API that allows you to check key details before actually running the obfuscated\n                            script, allowing you to implement custom logic without kicking the user. Click to read more.\n                        </p>\n                    </div>\n                </div>\n\n                <div class=\"featureCard glass\"\n                    onclick=\"window.open(",
    "s right for you.</p>\n            </div>\n            <div class=\"pricingGrid\">\n                <div class=\"priceCard glass\">\n                    <h3>Basic</h3>\n                    <p class=\"priceSubtitle\">If you just started developing scripts, this plan is ideal for you. You can\n                        always switch to a higher plan anytime you want!</p>\n                    <div class=\"priceAmount\">\n                        <span class=\"price\">$15</span>\n                        <span class=\"period\">/month</span>\n                    </div>\n                    <ul class=\"priceFeatures\">\n                        <li class=\"included\">â API & Bot access</li>\n                        <li class=\"included\">â Webhook logs</li>\n                        <li class=\"included\">â Up to 200 keys at once</li>\n                        <li class=\"included\">â Unlimited obf per month</li>\n                        <li class=\"included\">â Up to 2 scripts at once</li>\n                        <li class=\"included\">â 1 project folder</li>\n                        <li class=\"included\">â Ad system (rewards)</li>\n                        <li class=\"excluded\">Ã Keyless (FFA) mode</li>\n                    </ul>\n                    <button class=\"priceButton\" onclick=\"openPaymentModal()\">Buy Invite</button>\n                </div>\n\n                <div class=\"priceCard glass\">\n                    <h3>Premium</h3>\n                    <p class=\"priceSubtitle\">Best plan for most users. If your script hub growing fast, this plan is\n                        recommended.</p>\n                    <div class=\"priceAmount\">\n                        <span class=\"price\">$25</span>\n                        <span class=\"period\">/month</span>\n                    </div>\n                    <ul class=\"priceFeatures\">\n                        <div class=\"popularBadge\">Most Popular</div>\n                        <li class=\"included\">â API & Bot access</li>\n                        <li class=\"included\">â Webhook logs</li>\n                        <li class=\"included\">â Up to <b style=\"color:rgba(226, 226, 226, 0.958)\">1,000</b> keys at once\n                        </li>\n                        <li class=\"included\">â Unlimited obf per month</li>\n                        <li class=\"included\">â Up to 8 scripts at once</li>\n                        <li class=\"included\">â 3 project folders</li>\n                        <li class=\"included\">â Ad system (rewards)</li>\n                        <li class=\"included\">â Keyless (FFA) mode</li>\n                    </ul>\n                    <button class=\"priceButton popular\" onclick=\"openPaymentModal()\">Buy Invite</button>\n                </div>\n\n                <div class=\"priceCard glass popular\">\n                    <h3>Pro</h3>\n                    <p class=\"priceSubtitle\">Everything in premium with higher usage limits. Recommended for high\n                        quality scripts with hundreds of buyers.</p>\n                    <div class=\"priceAmount\">\n                        <span class=\"price\">$40</span>\n                        <span class=\"period\">/month</span>\n                    </div>\n                    <ul class=\"priceFeatures\">\n                        <li class=\"included\">â API & Bot access</li>\n                        <li class=\"included\">â Webhook logs</li>\n                        <li class=\"included\">â Up to <b style=\"color:rgb(224, 138, 255)\">10,000</b> keys at once</li>\n                        <li class=\"included\">â <b style=\"color:rgb(224, 138, 255)\">Unlimited</b> obf per month</li>\n                        <li class=\"included\">â Up to <b style=\"color:rgb(224, 138, 255)\">18</b> scripts at once</li>\n                        <li class=\"included\">â 6 project folders</li>\n                        <li class=\"included\">â Ad system (rewards)</li>\n                        <li class=\"included\">â Keyless (FFA) mode</li>\n                    </ul>\n                    <button class=\"priceButton\" onclick=\"openPaymentModal()\">Buy Invite</button>\n                </div>\n\n                <div class=\"priceCard glass\">\n                    <h3>Enterprise</h3>\n                    <p class=\"priceSubtitle\">For large hubs with specialized needs. Enterprise users can request custom\n                        features.</p>\n                    <div class=\"priceAmount\">\n                        <span class=\"price\"></span>\n                        <span class=\"period\">Crypto Currencies only</span>\n                    </div>\n                    <ul class=\"priceFeatures\">\n                        <li class=\"included\">ð API ratelimit bypass</li>\n                        <li class=\"included\">ð Advanced access control methods\n                            <small style=\"display: block; font-size: 0.9em; color: #666; margin-top: 5px;\">\n                                * e.g max instance limit per key, execution cap, hwid-less (only key) execution, clonned\n                                emulator blocking / allowing etc.\n                            </small>\n                        </li>\n                        <li class=\"included\">ð Custom URLs in ad system\n                            <small style=\"display: block; font-size: 0.9em; color: #666; margin-top: 5px;\">\n                                * e.g ads.luarmor.net/godhub\n                            </small>\n                        </li>\n\n                        <li class=\"included\">â 50k keys & 60 scripts</li>\n                        <li class=\"included\">â 10 projects & unlimited obf.</li>\n                        <li class=\"included\">+ Everything in Pro</li>\n                    </ul>\n                    <button class=\"priceButton\" onclick=\"window.open(",
    ";\n        }\n\n        function redirectToCrypto() {\n            window.open(",
    ");\n        }\n        function redirectToCard() {\nwindow.open(",
    ");\n--            window.open(",
    ");\n        }\n\tfunction redirectToPaypal() {\n\t\twindow.open(",
    ");\n\t}\n\n\tfunction redirectToRus() {\n\t\twindow.open(",
  },
  remotes = {
  },
  strings = {
    "X-UA-Compatible",
    "IE=edge",
    "viewport",
    "width=device-width, initial-scale=1",
    "Content-Security-Policy",
    "upgrade-insecure-requests",
    "icon",
    "image/png",
    "assets/img/lth.png",
    "theme-color",
    "og:type",
    "website",
    "og:title",
    "Luarmor - Lua Whitelist Service",
    "og:site_name",
    "ð Luarmor",
    "og:description",
    "Luarmor is a script whitelisting service made for Roblox.\n\n    Check out our website for details\n    https:--luarmor.net/",
    "og:image",
    "width=device-width, initial-scale=1.0",
    "stylesheet",
    "./newlanding/main.css",
    "topbar",
    "navLeft",
    "./newlanding/logo.png",
    "Luarmor Logo",
    "luarmorText gradient-text gradient-gold",
    "desktop-menu",
    "navCenter desktop-menu",
    "navRight",
    "signIn",
    "signUp",
    "menu-toggle",
    "mobile-menu",
    "heroSection",
    "hero-video",
    "thing.mp4",
    "video/mp4",
    "featureCard glass",
    "iconCircle",
    "servicesSection",
    "servicesContainer",
    "servicesHeader",
    "servicesTitle",
    "gradient-text",
    "statsSection",
    "container",
    "statsHeader",
    "heroTitle",
    "heroDescription",
    "statsGrid",
    "statCard glass",
    "display: block; font-size: 0.75em; color: #666; margin-top: 5px;",
    "display: block; font-size: 0.9em; color: #464646; margin-top: 5px;",
    "pricingSection",
    "prices",
    "pricingHeader",
    ").style.display = ",
    ";\n        }\n\n        function closePaymentModal() {\n            document.getElementById(",
    ");\n\t}\t\n\n   function toggleMobileMenu() {\n    var mobileMenu = document.querySelector(",
    ");\n    mobileMenu.classList.toggle(",
    ");\n  }\n  \n  -- Attach click listener to the hamburger button\n  document.querySelector(",
    ").addEventListener(",
  },
}

-- discovered fetch targets
-- https:--luarmor.net
-- https:--media.discordapp.net/attachments/973020490530689094/1030611589302333481/lth.png
-- https:--fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap

-- observed call sites with literal arguments
-- window.open("https:--docs.luarmor.net/")
-- window.open("https:--discord.gg/luarmor")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q")
-- window.open("https:--luarmor.net/login")
-- window.open("https:--luarmor.net/signup")
-- window.open("https:--docs.luarmor.net/")
-- window.open("https:--discord.gg/luarmor")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q#discord-bot-configuration")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q#id-3-whitelist-users")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q#runtime-variables")
-- window.open("https:--docs.luarmor.net/source-locker")
-- window.open("https:--docs.luarmor.net/ad-system-rewards")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q#key-check-library")
-- window.open("https:--docs.luarmor.net/luarmor-user-manual-and-f.a.q#id-2-upload-your-script")
-- window.open("https:--discord.gg/luarmor")
-- document.getElementById("payment-modal-overlay")
-- document.getElementById("payment-modal-overlay")
-- window.open("https:--luarmor.net/crypto")
-- window.open("https:--angxlzz.store/product/luarmor/")
-- window.open("https:--angxlzzstore.sellhub.cx/product/luarmor/")
-- window.open("https:--zephyrion.sell.app/")
-- window.open("https:--funpay.com/en/users/7412687/")
-- document.querySelector(".mobile-menu")
-- mobileMenu.classList.toggle("open")
-- document.querySelector(".menu-toggle")
-- .addEventListener("click")

return recovered