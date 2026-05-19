import Foundation

struct RemedyDatabase {
    // MARK: - All Remedies

    static let triphalaGinger = Remedy(
        name: "Triphala & Ginger Decoction",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🌿",
        color: "#B03020",
        ingredientDetails: [
            IngredientDetail(
                name: "Triphala powder",
                what: "A classical Ayurvedic blend of three dried fruits — amalaki, bibhitaki, and haritaki — used for over 2,000 years as a gentle digestive tonic and detoxifier.",
                why: "Triphala gently cleanses the colon, reduces Ama (metabolic waste), and tonifies the digestive tract without dependency.",
                whereToBuy: "Indian grocery stores, health food stores, or online via verified botanical distributors or organic food repositories.",
                safety: "Start with a small dose — may cause loose stools initially. Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use."
            ),
            IngredientDetail(
                name: "Fresh ginger root",
                what: "A warming rhizome (underground stem) whose active compounds — gingerols and shogaols — are among the most studied anti-inflammatory and digestive agents in natural medicine.",
                why: "Ginger stimulates digestive enzymes and bile production, and amplifies Triphala's cleansing action by warming the digestive tract.",
                whereToBuy: "Any grocery store, fresh produce section.",
                safety: "Generally safe at culinary doses. May thin blood at high therapeutic doses."
            ),
            IngredientDetail(
                name: "Black pepper",
                what: "A common spice containing piperine — a compound that dramatically increases the absorption of other herbs and nutrients.",
                why: "Piperine can increase absorption of other botanicals by up to 2000%, making Triphala's active compounds significantly more bioavailable.",
                whereToBuy: "Any grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Honey",
                what: "Raw, unprocessed honey that retains active enzymes, antimicrobial compounds, and prebiotic sugars. In Ayurveda, honey is called Yogavahi — a substance that carries other herbs deeper into tissues.",
                why: "Acts as a carrier (Yogavahi) that drives the herbs into tissues, and soothes the digestive lining.",
                whereToBuy: "Health food stores or farmers markets. Look for raw and unfiltered on the label.",
                safety: "Never add honey to boiling liquid — Ayurveda considers heated honey damaging to the digestive tract. Add only after cooling below 40°C / 104°F."
            ),
            IngredientDetail(
                name: "Warm water",
                what: "The delivery medium for this decoction. In Ayurveda, warm water itself is considered medicinal — it activates Agni (digestive fire) and aids absorption.",
                why: "Warm water activates Agni more effectively than cold and ensures the herbs are fully dissolved and bioavailable.",
                whereToBuy: "No sourcing needed.",
                safety: nil
            )
        ],
        desc: "A foundational Ayurvedic cleansing tonic combining the three fruits of Triphala — amalaki, bibhitaki, and haritaki — with warming ginger to stimulate Agni (digestive fire), historically associated with supporting the body's natural elimination pathways, and restore balance to all three doshas.",
        steps: [
            "Traditionally, Ayurvedic vaidyas began this decoction by bringing two cups of water to a boil with one teaspoon of Triphala powder and half a teaspoon of freshly grated ginger root.",
            "The mixture was simmered on low heat for ten minutes, then removed from the flame and allowed to steep undisturbed for five more — a resting period classical Ayurvedic texts described as allowing Agni to settle into the brew.",
            "Healers strained the liquid into a cup and added a pinch of black pepper to activate piperine, allowing the preparation to cool to a comfortably warm drinking temperature.",
            "Raw honey — never added to hot liquid, as Ayurvedic tradition held that heated honey became harmful — was stirred in last. The tonic was consumed thirty minutes before sleep each evening."
        ],
        duration: 21,
        disclaimer: "Triphala is a gentle natural laxative and may cause loose stools in the first few days — this is normal and should stabilize by Day 3. Avoid this protocol during pregnancy. If you have IBS or inflammatory bowel conditions, consult a practitioner before starting.",
        citations: [
            RemedyCitation(
                text: "Pole, S. Ayurvedic Medicine: The Principles of Traditional Practice. Churchill Livingstone, 2006.",
                url: "https://www.elsevier.com/books/ayurvedic-medicine/pole/978-0-443-10090-1"
            ),
            RemedyCitation(
                text: "Baliga, M.S. et al. Triphala, Ayurvedic formulation for treating and preventing cancer. J Exp Ther Oncol. 2012.",
                url: "https://pubmed.ncbi.nlm.nih.gov/23272505/"
            )
        ]
    )

    static let ashwagandhaGoldenMilk = Remedy(
        name: "Ashwagandha Golden Milk",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🥛",
        color: "#B03020",
        ingredientDetails: [
            IngredientDetail(
                name: "Ashwagandha root powder",
                what: "The root of Withania somnifera, an adaptogenic shrub used in Ayurveda for over 3,000 years. Its active compounds — withanolides — modulate the stress response system (HPA axis) and support adrenal function.",
                why: "Ashwagandha directly addresses deep fatigue by tonifying the adrenal glands, reducing cortisol, and rebuilding Ojas — the vital essence that governs immunity and energy reserves.",
                whereToBuy: "Health food stores, Indian grocery stores, or online via verified botanical distributors or organic food repositories.",
                safety: "Literature notes potential interactions with thyroid medication pathways. Consult a healthcare provider for personal cross-reference. Literature notes potential interactions with immunosuppressant pathways. Consult a healthcare provider for personal cross-reference. Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use. If you have a thyroid condition, consult your doctor before starting."
            ),
            IngredientDetail(
                name: "Turmeric",
                what: "A bright yellow rhizome whose active compound — curcumin — is one of the most well-studied anti-inflammatory agents in natural medicine. It is fat-soluble and requires a lipid carrier for absorption.",
                why: "Curcumin reduces systemic inflammation associated with chronic fatigue, and synergizes with ashwagandha's adaptogenic action. The milk fat in this recipe ensures absorption.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: "High doses may interact with blood-thinning medications. Use culinary amounts as directed."
            ),
            IngredientDetail(
                name: "Cinnamon",
                what: "True Ceylon cinnamon (Cinnamomum verum) — not cassia — is a warming spice that helps balance blood sugar and enhances the digestive and warming qualities of this formula.",
                why: "Stabilizes blood sugar fluctuations that contribute to afternoon energy crashes, and adds warming Agni-kindling properties to support absorption.",
                whereToBuy: "Health food stores. Look specifically for Ceylon cinnamon (lighter in color, milder flavor) rather than cassia (the common grocery store variety).",
                safety: "Cassia cinnamon (most grocery store cinnamon) contains coumarin and can affect the liver in large amounts over time. Use Ceylon cinnamon for this protocol."
            ),
            IngredientDetail(
                name: "Cardamom",
                what: "An aromatic seed pod used in Ayurveda as a digestive, nervine, and respiratory herb. Contains 1,8-cineole and terpinyl acetate.",
                why: "Soothes the digestive tract and enhances the absorption of ashwagandha, while adding a pleasant flavor that balances the earthiness of the root.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Warm whole milk or oat milk",
                what: "The liquid base of the formula. Fat is biologically necessary to dissolve and transport ashwagandha's withanolides and turmeric's curcumin across the intestinal wall.",
                why: "Without a fat-containing carrier, both ashwagandha and turmeric pass through the digestive tract largely unabsorbed. Full-fat milk or oat milk with added fat provides the lipid matrix required.",
                whereToBuy: "Any grocery store. For dairy-free, use full-fat oat milk or coconut milk.",
                safety: nil
            )
        ],
        desc: "Ashwagandha, the revered Ayurvedic adaptogen, is blended with turmeric and warming spices into a nourishing golden milk. This protocol addresses deep fatigue by tonifying the adrenals, calming the nervous system, and rebuilding Ojas — the vital essence of immunity and vitality.",
        steps: [
            "In classical Ayurvedic households, this formula was prepared by gently warming one and a half cups of whole milk over medium heat — never brought to a full boil, as boiling was considered to damage the milk's Ojas-building properties.",
            "One teaspoon of ashwagandha powder, half a teaspoon of turmeric, a quarter teaspoon of cinnamon, and a pinch of cardamom were whisked in together until fully dissolved into the lipid medium.",
            "The blend was simmered gently for five minutes with continuous stirring — a step that traditional practitioners emphasized for ensuring the fat-soluble compounds fully merged with the warm milk base.",
            "Poured into a cup and lightly sweetened with honey or maple syrup, this golden milk was consumed each morning upon rising, before any food was taken."
        ],
        duration: 30,
        disclaimer: "Ashwagandha can influence thyroid hormone levels and cortisol. If you take thyroid medication, sedatives, or immunosuppressants, consult your doctor before starting. Not recommended during pregnancy or breastfeeding. Results typically become noticeable after 2–3 weeks of consistent use.",
        citations: [
            RemedyCitation(
                text: "Chandrasekhar, K. et al. A prospective, randomized double-blind study of ashwagandha root in reducing stress and anxiety. Indian J Psychol Med. 2012;34(3):255–262.",
                url: "https://pubmed.ncbi.nlm.nih.gov/23439798/"
            ),
            RemedyCitation(
                text: "Welch, C. Balance Your Hormones, Balance Your Life. Da Capo Lifelong Books, 2011.",
                url: "https://www.hachettebookgroup.com/titles/claudia-welch/balance-your-hormones-balance-your-life/9780738215174/"
            )
        ]
    )

    static let neemTurmericTea = Remedy(
        name: "Neem & Turmeric Detox Tea",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🍃",
        color: "#B03020",
        ingredientDetails: [
            IngredientDetail(
                name: "Dried neem leaf",
                what: "Leaves of Azadirachta indica — called 'the village pharmacy' across India. Rich in nimbin, nimbidin, and azadirachtin. One of Ayurveda's most powerful blood purifiers and bitter tonics.",
                why: "Clears heat and toxins (Pitta and Ama) from the blood and lymphatic system, addressing skin conditions at their root rather than suppressing symptoms at the surface.",
                whereToBuy: "Indian grocery stores, verified botanical distributors or organic food repositories (online).",
                safety: "Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use — may stimulate uterine contractions. Not suitable for children under 12. Use only leaf preparations; neem oil is not safe for internal use."
            ),
            IngredientDetail(
                name: "Turmeric root or powder",
                what: "A rhizome whose curcumin content has been shown to modulate over 160 physiological pathways, including NF-kB — a master regulator of inflammation — and to support liver detoxification.",
                why: "Directly reduces skin inflammation and supports the liver's ability to filter and clear the blood-borne triggers that drive chronic skin conditions.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: "High doses may interact with blood-thinning medications. Culinary doses as directed are safe."
            ),
            IngredientDetail(
                name: "Licorice root",
                what: "Root of Glycyrrhiza glabra, used in both Ayurveda and TCM as a harmonizer and soother. Glycyrrhizin coats and protects mucous membranes and modulates inflammatory responses.",
                why: "Soothes the bitter intensity of neem, protects the digestive lining during cleansing, and adds its own anti-inflammatory action.",
                whereToBuy: "Health food stores or verified botanical distributors or organic food repositories. Look for cut root pieces, not candy.",
                safety: "Not for people with high blood pressure, kidney disease, or edema — glycyrrhizin raises blood pressure at therapeutic doses. Limit to 14-day courses as directed."
            ),
            IngredientDetail(
                name: "Coriander seeds",
                what: "Seeds of Coriandrum sativum — a cooling digestive herb that reduces Pitta (heat) and supports kidney function. Used in Ayurveda to cool and balance the formula.",
                why: "Counteracts the heat generated by neem and turmeric, protecting the digestive tract while supporting urinary clearance of toxins.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "Unprocessed honey with active enzymes, antimicrobial compounds, and antioxidants. In Ayurveda, honey added to cooled preparations acts as Yogavahi — carrying herbs into deeper tissues.",
                why: "Enhances absorption of the formula's active compounds and soothes the digestive tract after the cleansing action of neem.",
                whereToBuy: "Health food stores or farmers markets.",
                safety: "Add only after the tea has cooled below 40°C / 104°F. Never heat raw honey."
            )
        ],
        desc: "Neem, called 'the village pharmacy' in India, is one of Ayurveda's most powerful blood purifiers. Combined with anti-inflammatory turmeric and soothing licorice, this tea addresses skin irritations at their root — clearing heat, toxins, and Pitta imbalance from the blood and lymphatic system.",
        steps: [
            "In traditional Ayurvedic practice, this blood-purifying decoction was prepared by bringing two cups of water to a boil, into which one teaspoon of dried neem leaves and half a teaspoon of coriander seeds were added.",
            "Half a teaspoon of turmeric and a small piece of licorice root were introduced, the heat reduced to a gentle simmer, and the brew was decocted for twelve minutes — the extended time considered necessary to fully draw out neem's bitter purifying compounds.",
            "The tea was strained and allowed to cool until comfortably warm — Ayurvedic practice held that neem's cooling properties were best preserved when the preparation was consumed below boiling temperature.",
            "One teaspoon of raw honey was added only after cooling, and the preparation was consumed once daily on an empty stomach in the morning — the timing the classical texts emphasized for optimal blood-purifying action."
        ],
        duration: 14,
        disclaimer: "Neem is a potent blood-purifying herb and should not be used during pregnancy or by children under 12. Licorice root raises blood pressure — avoid if you have hypertension, kidney disease, or edema. Limit this protocol to 14 days as directed. If skin symptoms worsen significantly, discontinue and consult a practitioner.",
        citations: [
            RemedyCitation(
                text: "Subapriya, R. & Nagini, S. Medicinal properties of neem leaves: a review. Curr Med Chem Anticancer Agents. 2005;5(2):149–156.",
                url: "https://pubmed.ncbi.nlm.nih.gov/15777222/"
            ),
            RemedyCitation(
                text: "Bhishagratna, K.K. (trans.) Sushruta Samhita. Chaukhamba Sanskrit Pratishthan, 1991.",
                url: "https://archive.org/details/SushrutaSamhita"
            )
        ]
    )

    static let boswelliaTurmericPaste = Remedy(
        name: "Boswellia & Turmeric Paste",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🫚",
        color: "#B03020",
        ingredientDetails: [
            IngredientDetail(
                name: "Boswellia serrata resin or powder",
                what: "Resin from the Boswellia serrata tree, known in Sanskrit as Shallaki. Contains boswellic acids — particularly AKBA (acetyl-11-keto-β-boswellic acid) — that selectively inhibit the 5-LOX enzyme pathway responsible for producing pro-inflammatory leukotrienes.",
                why: "AKBA targets the same inflammatory pathway as many prescription anti-inflammatories, but without the gastrointestinal side effects associated with NSAIDs.",
                whereToBuy: "Health food stores or verified botanical distributors or organic food repositories.",
                safety: "Generally well-tolerated. May interact with anti-inflammatory medications — consult your doctor if you take NSAIDs or prescription arthritis medication."
            ),
            IngredientDetail(
                name: "Turmeric powder",
                what: "Curcumin in turmeric inhibits NF-kB and COX-2 — two central regulators of the inflammatory response — through a different mechanism than boswellic acids, creating a synergistic anti-inflammatory effect.",
                why: "Curcumin and boswellic acids work on complementary pathways, providing broader anti-inflammatory coverage than either herb alone.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: "High doses may interact with blood-thinning medications. Use as directed."
            ),
            IngredientDetail(
                name: "Black pepper",
                what: "Contains piperine, a compound that dramatically increases curcumin bioavailability by inhibiting its rapid metabolism in the liver and intestines.",
                why: "Without piperine, over 90% of curcumin is metabolized before reaching systemic circulation. Even a small amount of black pepper makes this formula significantly more effective.",
                whereToBuy: "Any grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Ghee (clarified butter)",
                what: "Clarified butter with milk solids removed. In Ayurveda, ghee is classified as a Snehana (oleation) agent that carries fat-soluble compounds — including curcumin and boswellic acids — through the intestinal wall and into tissues.",
                why: "Both turmeric and boswellia are fat-soluble. Ghee dramatically increases their absorption and simultaneously nourishes the joint tissues and synovial membranes.",
                whereToBuy: "Indian grocery stores, health food stores, or any grocery store. Look for grass-fed ghee.",
                safety: "Those with dairy allergies may substitute virgin coconut oil, which provides a similar lipid carrier effect."
            ),
            IngredientDetail(
                name: "Ginger powder",
                what: "Dried ginger root with concentrated shogaols — warming compounds that improve peripheral circulation and reduce inflammatory prostaglandins through COX inhibition.",
                why: "Increases blood flow to affected joints, enhancing the delivery of the anti-inflammatory compounds, and adds its own independent anti-inflammatory activity.",
                whereToBuy: "Any grocery store.",
                safety: "Avoid high therapeutic doses if taking blood-thinning medications."
            )
        ],
        desc: "Boswellia — known as Shallaki in Sanskrit — has been used in Ayurveda for millennia to support joint comfort and restore ease of movement. This golden paste combines its active boswellic acids with turmeric's curcumin, amplified by black pepper's piperine for maximum bioavailability.",
        steps: [
            "Shallaki paste was historically prepared by Ayurvedic practitioners by combining one teaspoon each of boswellia and turmeric powder with half a teaspoon of ginger powder and a quarter teaspoon of black pepper in a small bowl.",
            "A tablespoon of ghee — classified as a Snehana (oleation) carrier in Ayurveda — was warmed gently in a pan, then the herb mixture was stirred in and worked into a smooth, cohesive paste over low heat.",
            "The pan was removed from heat and allowed to cool slightly; the paste was stored in a small sealed vessel, as classical texts noted it could be prepared in advance and kept for several days.",
            "Half a teaspoon of the paste was taken with warm water or milk. Practitioners also applied a small amount topically to areas of joint discomfort and massaged gently — a dual internal and external application documented in classical Ayurvedic joint protocols."
        ],
        duration: 21,
        disclaimer: "If you take NSAIDs, prescription anti-inflammatories, or blood-thinning medications, consult your doctor before combining them with this protocol — both boswellia and turmeric have anti-inflammatory and mild blood-thinning properties. Topical application is an adjunct practice, not a substitute for professional care for acute joint injuries.",
        citations: [
            RemedyCitation(
                text: "Siddiqui, M.Z. Boswellia serrata, a potential antiinflammatory agent: an overview. Indian J Pharm Sci. 2011;73(3):255–261.",
                url: "https://pubmed.ncbi.nlm.nih.gov/22457547/"
            ),
            RemedyCitation(
                text: "Lad, V. Textbook of Ayurveda, Volume 1: Fundamental Principles. Ayurvedic Press, 2002.",
                url: "https://www.ayurvedapress.com/product/textbook-of-ayurveda-volume-1/"
            )
        ]
    )

    static let agniStimulatingBitters = Remedy(
        name: "Agni Stimulating Bitters",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🌱",
        color: "#B03020",
        ingredientDetails: [
            IngredientDetail(
                name: "Trikatu (ginger, black pepper, long pepper)",
                what: "A classical Ayurvedic compound formula of three warming spices — shunthi (dry ginger), maricha (black pepper), and pippali (long pepper). Documented in the Charaka Samhita as a premier digestive stimulant.",
                why: "Trikatu kindles Agni (digestive fire), stimulates digestive enzyme and bile secretion, reduces Ama (metabolic waste), and drives other herbs deeper into the tissues.",
                whereToBuy: "Indian grocery stores, verified botanical distributors or organic food repositories. Often sold pre-blended as 'Trikatu powder'.",
                safety: "Contraindicated in Pitta conditions such as acid reflux or GERD — these warming herbs can aggravate excess stomach heat. Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use."
            ),
            IngredientDetail(
                name: "Dried orange peel",
                what: "The zest of citrus, dried to concentrate its bitter compounds — hesperidin and nobiletin — which are classified as bitter digestive stimulants (bitters) in European and Ayurvedic traditions alike.",
                why: "Bitter taste directly triggers digestive secretions via the vagus nerve reflex, priming the stomach for a meal. Orange peel adds flavor while delivering real digestive benefit.",
                whereToBuy: "Health food stores or dried naturally at home. Avoid commercially sweetened or flavored peel.",
                safety: nil
            ),
            IngredientDetail(
                name: "Cumin seeds",
                what: "Seeds of Cuminum cyminum containing thymoquinone and cumin aldehydes — compounds shown to stimulate the release of digestive enzymes from the pancreas.",
                why: "Directly stimulates enzyme production needed to break down proteins and fats, reducing the bloating and heaviness that often signals weak digestion.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Fennel seeds",
                what: "Seeds of Foeniculum vulgare — a carminative herb whose volatile oils (trans-anethole, fenchone) relax intestinal smooth muscle, relieving trapped gas and intestinal cramping.",
                why: "Prevents the gas and bloating that can occur as digestion improves and the gut begins moving more actively — counteracting the 'stirring up' effect of the Trikatu.",
                whereToBuy: "Any grocery store.",
                safety: "Avoid therapeutic doses during pregnancy. Safe at culinary amounts."
            ),
            IngredientDetail(
                name: "Apple cider vinegar",
                what: "Raw, unpasteurized ACV containing acetic acid and live Acetobacter culture (the 'mother'). Acetic acid mimics stomach acid, priming the digestive environment before meals.",
                why: "Stimulates stomach acid (HCl) production — a common deficiency in people with sluggish digestion — and lowers the pH of the gastric environment to optimize enzyme function.",
                whereToBuy: "Any grocery store. Look for raw, unfiltered ACV 'with the mother' — widely available at organic food repositories.",
                safety: "Always dilute as directed — undiluted ACV erodes tooth enamel over time. Rinse mouth after drinking. Not suitable for those with active GERD or peptic ulcers."
            )
        ],
        desc: "In Ayurveda, weak Agni — digestive fire — is considered the root of most disease. These warming bitters kindle Agni, stimulate digestive enzyme production, and restore the body's natural appetite signals. The Trikatu blend is a classical Ayurvedic formula documented in the Charaka Samhita.",
        steps: [
            "In classical Ayurvedic practice, this digestive bitters formula began with one teaspoon each of cumin and fennel seeds toasted dry in a pan for two minutes until fragrant, then ground coarsely — the toasting considered essential to activate the carminative volatile oils.",
            "The ground spices were combined with half a teaspoon of Trikatu blend and one teaspoon of dried orange peel in a small preparation jar — a combination classical texts called a premier Agni-kindling compound.",
            "One tablespoon of apple cider vinegar and two tablespoons of warm water were poured over the herbs and stirred well, creating the traditional pre-meal bitters preparation.",
            "This formula was consumed fifteen minutes before each meal — a timing considered essential in Ayurvedic tradition, as the bitters were meant to prime the digestive field before food arrived."
        ],
        duration: 14,
        disclaimer: "These bitters stimulate stomach acid production. Do not use if you have GERD, active acid reflux, or peptic ulcers — increasing stomach acid in these conditions can worsen symptoms. Trikatu is a heating formula that may cause discomfort in those with Pitta-type imbalances (frequent heartburn, skin redness, irritability).",
        citations: [
            RemedyCitation(
                text: "Lad, V. & Frawley, D. The Yoga of Herbs: An Ayurvedic Guide to Herbal Medicine. Lotus Press, 1986.",
                url: "https://www.lotuspress.com/product/yoga-of-herbs/"
            ),
            RemedyCitation(
                text: "Charaka Samhita, Sutrasthana 27 (Annaphala Varga — on properties of Trikatu). Circa 400–200 BCE.",
                url: "https://www.carakasamhitaonline.com/index.php?title=Sutrasthana"
            )
        ]
    )

    static let wormwoodCloveTonic = Remedy(
        name: "Wormwood & Clove Tonic",
        origin: "Traditional Chinese Medicine · China",
        tradition: "Traditional Chinese Medicine",
        tid: "tcm",
        icon: "🫖",
        color: "#C03030",
        ingredientDetails: [
            IngredientDetail(
                name: "Dried wormwood (Artemisia)",
                what: "Known as Qing Hao in TCM — a bitter, cold herb documented in the Bencao Gangmu by Li Shizhen (1578). Contains artemisinin and absinthin, which clear damp-heat from the middle jiao (digestive center).",
                why: "Directly addresses the TCM pattern of damp-heat in the stomach and intestines, which presents as bloating, nausea, foul breath, and a heavy, uncomfortable sensation after eating.",
                whereToBuy: "TCM herb shops or verified botanical distributors.",
                safety: "Contains thujone — do not exceed the stated dose. Not safe during pregnancy or for children under 12. Do not use for more than 14 days continuously."
            ),
            IngredientDetail(
                name: "Clove buds",
                what: "Known as Ding Xiang in TCM — a warming aromatic herb rich in eugenol, which has potent antifungal and antibacterial properties. It warms the middle jiao and descends rebellious Qi (addresses nausea and bloating).",
                why: "Counterbalances the cold nature of wormwood, ensuring the formula warms and activates rather than over-cooling the digestive system. Also directly addresses gas and bloating.",
                whereToBuy: "Any grocery store.",
                safety: "Safe at culinary doses. Clove oil (concentrated) is unsafe for internal use in large amounts."
            ),
            IngredientDetail(
                name: "Huang Lian (Coptis root)",
                what: "One of the bitterest herbs in the TCM pharmacopoeia — a premier damp-heat clearing agent. Its active compound berberine has been extensively studied for antimicrobial and gut-microbiome modulating properties.",
                why: "Clears fire toxins and damp-heat from the stomach and intestines, reducing microbial imbalances that drive bloating, and restoring harmonious Qi flow through the stomach meridian.",
                whereToBuy: "TCM herb shops or verified botanical distributors.",
                safety: "Berberine lowers blood sugar — monitor carefully if diabetic. Avoid during pregnancy. May interact with certain antibiotics and blood sugar medications."
            ),
            IngredientDetail(
                name: "Fresh ginger slices",
                what: "Known as Sheng Jiang in TCM — a warming harmonizer that moderates the cold, bitter properties of wormwood and Huang Lian, and reduces nausea.",
                why: "Prevents the cold nature of this formula from damaging the Spleen-Stomach (digestive center) and adds direct anti-nausea and digestive-stimulating action.",
                whereToBuy: "Any grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Dried tangerine peel (Chen Pi)",
                what: "The dried peel of Citrus reticulata, aged to concentrate its therapeutic properties. Known as Chen Pi ('aged peel') in TCM — a Qi-moving, damp-drying, and digestion-aiding herb.",
                why: "Moves stagnant Qi through the digestive tract (the root of bloating and gas in TCM), dries dampness, and makes the formula more fragrant and tolerable to drink.",
                whereToBuy: "TCM herb shops and Asian grocery stores. The older the peel, the better its quality.",
                safety: nil
            )
        ],
        desc: "This TCM digestive tonic combines Qing Hao (wormwood) — documented in the Bencao Gangmu by Li Shizhen — with warming cloves and the bitter detoxifier Huang Lian. Together they clear damp-heat from the middle jiao, reduce bloating, and restore harmonious Qi flow through the stomach meridian.",
        steps: [
            "Traditional TCM practitioners prepared this decoction by bringing three cups of water to a boil, then adding two grams of dried wormwood (Qing Hao), three clove buds, and a small piece of aged tangerine peel (Chen Pi).",
            "Two to three slices of fresh ginger and a measured pinch of Huang Lian were added, the heat reduced to a low simmer — a deliberate balancing of warming and cooling herbs that TCM theory described as harmonizing the middle jiao.",
            "The formula was decocted on low heat for twenty minutes, allowing the liquid to reduce to approximately two cups — the reduction considered essential for concentrating the damp-heat-clearing compounds into a potent medicinal dose.",
            "The strained decoction was divided into two equal portions and consumed warm — one cup before midday and the second before the evening meal — a twice-daily rhythm documented in Li Shizhen's classical materia medica."
        ],
        duration: 14,
        disclaimer: "Wormwood contains thujone and must not be exceeded beyond the stated dose or 14-day duration. Not safe during pregnancy or for children under 12. If you are diabetic or take blood sugar medication, monitor your levels carefully when using Huang Lian (berberine). This formula is quite bitter — that bitterness is part of how it works.",
        citations: [
            RemedyCitation(
                text: "Bensky, D., Clavey, S. & Stöger, E. Chinese Herbal Medicine: Materia Medica, 3rd ed. Eastland Press, 2004.",
                url: "https://eastlandpress.com/products/chinese-herbal-medicine-materia-medica-3rd-edition"
            ),
            RemedyCitation(
                text: "Li, Shizhen. Bencao Gangmu (Compendium of Materia Medica). 1578 CE. Translated by Luo, X. Foreign Languages Press, 2003.",
                url: "https://archive.org/details/bencao-gangmu"
            )
        ]
    )

    static let brahmiGinkgoBrew = Remedy(
        name: "Brahmi & Ginkgo Clarity Brew",
        origin: "Traditional Chinese Medicine · China",
        tradition: "Traditional Chinese Medicine",
        tid: "tcm",
        icon: "🧠",
        color: "#C03030",
        ingredientDetails: [
            IngredientDetail(
                name: "Brahmi (Bacopa monnieri) powder",
                what: "A water-soluble herb from Ayurveda — one of the most studied nootropic plants in modern research. Its active compounds (bacosides A and B) enhance synaptic communication and protect neurons from oxidative stress.",
                why: "Clinical trials show consistent improvement in memory, learning rate, and mental processing speed after 8–12 weeks of use. historically cataloged to support mental clarity: insufficient nourishment of the Majja dhatu (nerve tissue).",
                whereToBuy: "Health food stores or verified botanical distributors.",
                safety: "May mildly slow heart rate. Literature indicates potential interactions with specific cardiovascular pathways. Consult a healthcare provider for personal cross-reference. Not recommended for children without practitioner guidance."
            ),
            IngredientDetail(
                name: "Ginkgo biloba leaf",
                what: "Leaves of the Ginkgo biloba tree — one of the oldest living tree species on Earth, used in TCM for centuries. Its flavonoids (quercetin, kaempferol) and terpenoids (ginkgolides, bilobalide) improve blood flow to the brain and protect neurons from free radical damage.",
                why: "Increases cerebral microcirculation, delivering more oxygen and glucose to brain cells — directly addressing the cognitive sluggishness and poor recall associated with brain fog.",
                whereToBuy: "Health food stores or verified botanical distributors.",
                safety: "Literature notes potential interactions with anticoagulant pathways. Consult a healthcare provider for personal cross-reference — do not combine with warfarin, aspirin, NSAIDs, or other blood thinners. Stop use 2 weeks before any surgery."
            ),
            IngredientDetail(
                name: "He Shou Wu (Fo-Ti root)",
                what: "A revered TCM tonic herb (Polygonum multiflorum) that nourishes the liver and kidneys — the organ systems that govern cognitive sharpness and memory in TCM theory. Contains stilbene glycosides and emodin.",
                why: "Replenishes the Kidney-Brain axis (Jing essence) depleted by chronic stress and overwork — addressing the deeper root of mental fatigue beyond what circulation-enhancing herbs alone can correct.",
                whereToBuy: "TCM herb shops or online. Always purchase processed (Zhi) He Shou Wu — not raw.",
                safety: "Raw He Shou Wu has been linked to liver toxicity in documented case reports. Only use the processed (Zhi/prepared) form. Avoid combining with iron supplements, which bind to its anthraquinone content."
            ),
            IngredientDetail(
                name: "Dried wolfberries (Goji)",
                what: "Berries of Lycium barbarum — a TCM superfood tonic rich in zeaxanthin (protects retinal and brain cells), polysaccharides (immune-modulating), and betaine (liver-protective).",
                why: "Nourishes the Liver and Kidney Yin in TCM, supporting the foundation from which clear, sustained mental energy arises. Provides antioxidant protection to brain cells during the cleansing process.",
                whereToBuy: "Health food stores, Asian grocery stores, or any large grocery store.",
                safety: "Generally very safe. May mildly interact with blood thinners or diabetes medications at large therapeutic doses."
            ),
            IngredientDetail(
                name: "Green tea",
                what: "Leaves of Camellia sinensis providing two key cognitive compounds: L-theanine (an amino acid that promotes calm, focused alertness without sedation) and EGCG (a potent antioxidant that crosses the blood-brain barrier).",
                why: "L-theanine synergizes with the formula's other herbs to produce sustained mental clarity rather than jittery stimulation, while EGCG provides direct neuroprotection.",
                whereToBuy: "Any grocery store. Loose leaf green tea has higher EGCG content than bagged tea.",
                safety: "Contains caffeine — avoid taking this formula after 4 PM to preserve sleep quality."
            )
        ],
        desc: "A cross-traditional clarity formula drawing from both TCM and Ayurveda. Ginkgo biloba, a sacred TCM herb used for millennia, increases cerebral circulation. Brahmi, the Ayurvedic brain tonic, enhances memory and reduces mental fog. He Shou Wu nourishes the kidney-brain axis described in TCM theory.",
        steps: [
            "This cross-traditional clarity formula was prepared by steeping one teaspoon of ginkgo biloba leaf and one teaspoon of dried goji berries in two cups of just-boiled water for ten minutes — the just-boiled temperature, rather than a full rolling boil, considered ideal for preserving the delicate flavonoid compounds.",
            "After straining, the brew was gently reheated and one teaspoon of Brahmi powder was whisked in until fully dissolved — Ayurvedic practitioners held that warm (not hot) liquid activated the bacosides most effectively.",
            "Ten drops of processed (Zhi) He Shou Wu tincture — or half a teaspoon of the prepared powder — were added last to complete the classical TCM Kidney-Brain nourishing combination.",
            "One cup was consumed mid-morning and the second in the early afternoon. Classical practitioners of both traditions consistently noted that the formula should not be taken after four in the afternoon, as the green tea base would interfere with the evening's restorative rest."
        ],
        duration: 21,
        disclaimer: "Ginkgo biloba thins the blood — do not combine with warfarin, aspirin, or NSAIDs. Only use processed (Zhi) He Shou Wu; raw He Shou Wu has been linked to liver injury in case reports. Because this formula contains caffeine from green tea, avoid taking it after 4 PM. Full cognitive benefits typically require 4–8 weeks of consistent use.",
        citations: [
            RemedyCitation(
                text: "Stough, C. et al. The chronic effects of an extract of Bacopa monniera on cognitive function in healthy human subjects. Psychopharmacology. 2001;156(4):481–484.",
                url: "https://pubmed.ncbi.nlm.nih.gov/11498727/"
            ),
            RemedyCitation(
                text: "Kleijnen, J. & Knipschild, P. Ginkgo biloba for cerebral insufficiency. Lancet. 1992;340(8828):1136–1139.",
                url: "https://pubmed.ncbi.nlm.nih.gov/1359209/"
            )
        ]
    )

    static let saffronRhodiolaBlend = Remedy(
        name: "Saffron & Rhodiola Adaptogen Blend",
        origin: "Persian Medicine · Iran",
        tradition: "Persian Medicine",
        tid: "persian",
        icon: "🌸",
        color: "#7B35A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Persian saffron threads",
                what: "Stigmas of Crocus sativus — the world's most precious spice, with Iran producing over 90% of the global supply. Active compounds crocin and safranal modulate serotonin, dopamine, and norepinephrine reuptake — the same pathways targeted by many antidepressant medications.",
                why: "Ibn Sina (Avicenna) prescribed saffron in his Canon of Medicine to 'elevate the spirits and strengthen the heart.' Modern clinical trials confirm significant mood-brightening effects at 30mg/day over 6–8 weeks.",
                whereToBuy: "Persian or Middle Eastern grocery stores, specialty spice shops, or verified botanical distributors. Look for 'Super Negin' or 'Sargol' grade (deep red threads, no yellow styles).",
                safety: "Safe at culinary doses. At therapeutic doses (30mg+), saffron may stimulate uterine contractions — traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use. Always steep in warm water first to extract crocin."
            ),
            IngredientDetail(
                name: "Rhodiola rosea root powder",
                what: "Root of a Siberian alpine plant used in traditional medicine across Russia, Scandinavia, and Central Asia. Active compounds rosavins and salidrosides regulate the cortisol stress response and support mitochondrial energy production.",
                why: "Directly addresses the cortisol dysregulation that underlies mood instability and emotional reactivity. Clinical trials show reduced anxiety, improved stress resilience, and reduced fatigue within 2–4 weeks.",
                whereToBuy: "Health food stores or verified botanical distributors. Look for standardized extracts with ≥3% rosavins.",
                safety: "Has mild stimulant properties — avoid taking after 3 PM to preserve sleep. Literature notes potential interactions with monoamine oxidase inhibitor (MAOI) pathways. Consult a healthcare provider for personal cross-reference. If you are on antidepressants, consult your doctor before combining."
            ),
            IngredientDetail(
                name: "Rose water",
                what: "Steam-distilled hydrosol from Rosa damascena petals — a cornerstone of Persian Unani medicine. Contains citronellol and geraniol, which have documented anxiolytic and heart-calming (cardiotonic) properties.",
                why: "Used in Persian medicine as a Qalb (heart) tonic that calms emotional agitation and supports the nervous system. Also makes the formula deeply aromatic — scent itself is part of the therapeutic experience.",
                whereToBuy: "Middle Eastern grocery stores, health food stores, or online. Ensure it is food-grade rose water, not cosmetic rose water.",
                safety: "Ensure food-grade purchase. Cosmetic rose water may contain additives not safe for ingestion."
            ),
            IngredientDetail(
                name: "Cardamom",
                what: "Aromatic seed pods of Elettaria cardamomum — used extensively in Persian, Ayurvedic, and Arabic medicine as a digestive, nervine, and mood-brightening herb.",
                why: "Soothes the gut-brain axis, reducing the digestive tension that often accompanies anxiety and mood changes, and adds warm, elevating aromatic notes to the formula.",
                whereToBuy: "Any grocery store or Indian/Middle Eastern grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "In Persian Unani medicine, honey (Asal) is classified as a Mufradat — a single-ingredient medicine with broad healing properties. Raw honey provides antimicrobial compounds, prebiotic sugars, and trace minerals.",
                why: "Acts as a carrier and harmonizer, making the formula more bioavailable, and adds its own calming, restorative properties to the blend.",
                whereToBuy: "Health food stores or farmers markets.",
                safety: "Do not heat above 40°C / 104°F — add after the formula cools slightly."
            )
        ],
        desc: "Ibn Sina (Avicenna) wrote extensively on saffron's power to elevate the spirits and strengthen the heart in his Canon of Medicine. This blend pairs royal saffron — the most prized Persian botanical — with adaptogenic Rhodiola to regulate cortisol, restore emotional resilience, and brighten mood through multiple pathways.",
        steps: [
            "In classical Persian practice, saffron was never added directly to boiling liquid. A generous pinch of threads — ten to fifteen — was first steeped in two tablespoons of warm water for ten minutes until the liquid turned a deep golden amber.",
            "One and a half cups of water or oat milk were warmed separately, and half a teaspoon of Rhodiola powder and a quarter teaspoon of cardamom were whisked in — a step Persian healers described as awakening the adaptogens.",
            "The golden saffron water and one teaspoon of food-grade rose water were added to the warm blend and stirred gently — the rose water, in Persian Unani tradition, was considered equally a medicine for the heart as for the body.",
            "Sweetened with one teaspoon of raw honey, this tonic was consumed each morning. Traditional Persian physicians prescribed three slow, mindful breaths before the first sip as an integral part of the therapeutic practice."
        ],
        duration: 21,
        disclaimer: "Rhodiola has mild stimulant properties — take this formula in the morning, not evening. If you take SSRIs, MAOIs, or other antidepressants, consult your doctor before adding Rhodiola. At therapeutic doses, saffron may stimulate uterine contractions and is not recommended during pregnancy. This formula supports mood — it is not a substitute for professional mental health care.",
        citations: [
            RemedyCitation(
                text: "Akhondzadeh, S. et al. Comparison of Crocus sativus L. and imipramine in the treatment of mild to moderate depression. BMC Complement Altern Med. 2004;4:12.",
                url: "https://pubmed.ncbi.nlm.nih.gov/15341662/"
            ),
            RemedyCitation(
                text: "Ibn Sina (Avicenna). Al-Qanun fi al-Tibb (Canon of Medicine). 1025 CE. Translated by O. Cameron Gruner. AMS Press, 1973.",
                url: "https://archive.org/details/canonofmedicinev00avic"
            )
        ]
    )

    static let papayaSeedHoney = Remedy(
        name: "Papaya Seed & Honey Protocol",
        origin: "Southeast Asian Folk Medicine · Thailand",
        tradition: "Southeast Asian Folk Medicine",
        tid: "folk",
        icon: "🍈",
        color: "#C08010",
        ingredientDetails: [
            IngredientDetail(
                name: "Fresh papaya seeds",
                what: "The black seeds found inside a ripe papaya, typically discarded. They contain carpaine (an alkaloid), benzyl isothiocyanate (an isothiocyanate), and proteolytic enzymes — compounds revered in Thai, Indonesian, and Filipino traditional healing for digestive cleansing.",
                why: "Used across the Jamu tradition of Java and Thai folk medicine as a 7-day intensive digestive cleanse. Proteolytic enzymes help break down proteins in the gut, while carpaine supports the gut environment.",
                whereToBuy: "Any grocery store that sells fresh whole papaya — seeds are inside and usually discarded. Use only seeds from ripe (orange/yellow) papaya, not green.",
                safety: "Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use — carpaine may stimulate uterine contractions. Limit to 7 days as directed. Not for children under 12."
            ),
            IngredientDetail(
                name: "Raw wildflower honey",
                what: "Unprocessed honey from bees that forage multiple wild flower species. Contains hydrogen peroxide, defensin-1 (a bee-derived antimicrobial peptide), and diverse prebiotic sugars that selectively feed beneficial gut bacteria.",
                why: "Provides antimicrobial support to the digestive environment while simultaneously feeding beneficial flora — a prebiotic action that helps restore microbial balance during and after the cleanse.",
                whereToBuy: "Health food stores or farmers markets. Look for 'raw' and 'unfiltered' on the label. Local wildflower honey is preferred over monofloral commercial varieties.",
                safety: "Not for infants under 12 months (risk of infant botulism). Never heat raw honey — it destroys the active compounds."
            ),
            IngredientDetail(
                name: "Coconut oil",
                what: "Cold-pressed, unrefined coconut oil rich in medium-chain triglycerides (MCTs) — particularly lauric acid, which converts to monolaurin in the body, a compound with documented antimicrobial properties.",
                why: "Supports the gut mucosal lining and provides MCT-based antimicrobial activity complementary to the papaya seeds. In Thai folk medicine, coconut oil is considered a protective and strengthening food for the digestive organs.",
                whereToBuy: "Any grocery store. Look for unrefined, cold-pressed, extra virgin coconut oil.",
                safety: "Use as directed — coconut oil is high in saturated fat and should not replace cooking oils during the protocol."
            ),
            IngredientDetail(
                name: "Lime juice",
                what: "Freshly squeezed juice of limes, providing citric acid and vitamin C. Citric acid stimulates bile production and slightly acidifies the stomach environment, supporting digestion.",
                why: "Enhances the bioavailability of the papaya seed blend and provides a palatable brightness that balances the bitter, peppery flavor of the seeds.",
                whereToBuy: "Any grocery store. Always use fresh-squeezed — bottled lime juice is heated during processing, destroying enzyme activity.",
                safety: "Rinse your mouth with water after drinking to protect tooth enamel from prolonged citric acid exposure."
            ),
            IngredientDetail(
                name: "Turmeric",
                what: "A warming, anti-inflammatory rhizome used across Southeast Asian traditional medicine to soothe gut inflammation and support liver function during cleansing.",
                why: "Reduces inflammatory irritation in the gut lining that can occur during intensive digestive cleansing, supporting comfort and recovery throughout the 7-day protocol.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: nil
            )
        ],
        desc: "Used across Thailand, Indonesia, and the Philippines, papaya seeds contain carpaine and benzyl isothiocyanate — compounds that have been revered in traditional healing for digestive cleansing. This 7-day intensive protocol is drawn from Jamu tradition and Thai folk medicine for restoring gut harmony.",
        steps: [
            "In Thai and Jamu tradition, fresh papaya seeds were harvested from a fully ripe, orange-yellow papaya — the ripeness being considered essential — then rinsed carefully and laid on a clean cloth to air dry before preparation.",
            "One tablespoon of the prepared seeds was blended smooth with one tablespoon of raw honey, one teaspoon of fresh lime juice, and a pinch of turmeric — a combination documented across both Thai folk medicine and the Jamu tradition of Java.",
            "The blended preparation was consumed each morning on an empty stomach, at least thirty minutes before the first meal — the empty stomach timing considered essential to allow direct contact between the preparation and the digestive environment.",
            "A glass of warm water with several drops of coconut oil stirred in was taken immediately after — a traditional Thai practice of following intensive seed preparations with a protective oil to support the digestive lining."
        ],
        duration: 7,
        disclaimer: "Do not use this protocol during pregnancy — papaya seeds contain carpaine, which may stimulate uterine contractions. This is a traditional 7-day digestive cleanse, not a medical treatment for parasitic infections. If you suspect a parasitic infection, consult a doctor for proper diagnosis and treatment. Limit to 7 days as directed.",
        citations: [
            RemedyCitation(
                text: "Okeniyi, J.A. et al. Effectiveness of dried Carica papaya seeds against human intestinal parasitosis. J Med Food. 2007;10(1):194–196.",
                url: "https://pubmed.ncbi.nlm.nih.gov/17472487/"
            ),
            RemedyCitation(
                text: "Phuakupt, K. et al. Ethnobotany of medicinal plants used in Southern Thai traditional medicine. J Ethnopharmacol. 2019.",
                url: "https://pubmed.ncbi.nlm.nih.gov/30248389/"
            )
        ]
    )

    static let garlicThymeOxymel = Remedy(
        name: "Garlic & Thyme Oxymel",
        origin: "European Herbalism · Greece",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🧄",
        color: "#1A60A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Fresh garlic cloves",
                what: "Bulbs of Allium sativum — one of the most studied medicinal plants in history, referenced in the Ebers Papyrus (1500 BCE) and prescribed by Hippocrates. When crushed, garlic releases allicin via an enzyme reaction (allinase activation) that requires a 10-minute wait.",
                why: "Allicin has demonstrated broad-spectrum antimicrobial activity against gut pathogens while preserving beneficial bacteria — directly addressing the microbial dysbiosis that drives digestive issues.",
                whereToBuy: "Any grocery store. Fresh whole bulbs only — pre-minced garlic has dramatically lower allicin content due to enzyme deactivation during processing.",
                safety: "May thin the blood — caution if taking warfarin, aspirin, or anticoagulants. Can cause reflux in sensitive individuals. Always crush and wait 10 minutes before use to activate allicin."
            ),
            IngredientDetail(
                name: "Fresh or dried thyme",
                what: "Leaves of Thymus vulgaris — a Mediterranean herb whose volatile oils (thymol and carvacrol) are potent antimicrobials. Used by ancient Greeks and in European monastic medicine as a digestive and respiratory herb.",
                why: "Thymol inhibits pathogenic bacteria and yeasts that contribute to digestive dysbiosis, while also stimulating digestive secretions and relieving intestinal spasms.",
                whereToBuy: "Any grocery store. Fresh thyme has higher thymol content; dried is also effective.",
                safety: "Safe at culinary doses. Avoid high therapeutic doses during pregnancy."
            ),
            IngredientDetail(
                name: "Raw apple cider vinegar",
                what: "Unpasteurized ACV containing acetic acid and live Acetobacter culture (the 'mother' — visible as cloudy strands). Hippocrates used oxymel — a mixture of vinegar and honey — as a medicine for multiple conditions, documented in 'On the Nature of Man.'",
                why: "Provides the acidic medium of the oxymel that inhibits pathogens, supports low stomach acid, and serves as the extraction medium that draws the active compounds from garlic and thyme.",
                whereToBuy: "Any grocery store. Look for raw, unfiltered ACV with 'the mother' — widely available at organic food repositories.",
                safety: "Always dilute as directed — undiluted ACV erodes tooth enamel. Not suitable for those with active peptic ulcers or GERD."
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "The sweet counterpart to vinegar in the classical oxymel preparation. In European herbalism, honey serves both as a preservative that extends the formula's shelf life and as a medicine that soothes and heals the gut lining.",
                why: "Antimicrobial compounds in raw honey (hydrogen peroxide, defensin-1) complement the formula's action, while prebiotic sugars support the growth of beneficial bacteria.",
                whereToBuy: "Health food stores or farmers markets. Raw and unfiltered for maximum therapeutic activity.",
                safety: "Do not heat — add raw to the oxymel preparation and stir to combine. Not for infants under 12 months."
            ),
            IngredientDetail(
                name: "Fennel seeds",
                what: "Seeds of Foeniculum vulgare — a carminative and antispasmodic herb used in European folk medicine to relieve gas, bloating, and intestinal cramping.",
                why: "Prevents the gas and bloating that can occur as gut motility increases during the protocol, and adds a pleasant anise-like flavor that makes the oxymel more palatable.",
                whereToBuy: "Any grocery store.",
                safety: "Avoid large therapeutic doses during pregnancy. Safe at culinary amounts."
            )
        ],
        desc: "An oxymel — a classical Greek preparation meaning 'acid and honey' — was documented by Hippocrates as a vehicle for delivering bitter and pungent herbs. This European formula uses garlic's allicin and thyme's thymol to address digestive dysbiosis, improve gut motility, and restore the terrain of the intestinal flora.",
        steps: [
            "The Greek oxymel tradition required that garlic be crushed and left to rest for ten full minutes before any other preparation step — a practice Hippocratic physicians understood to be essential for enzymatic activation of the medicinal compounds.",
            "The rested garlic was combined with two tablespoons of fresh thyme leaves and one teaspoon of fennel seeds in a small jar — an aromatic herb combination documented in both Greek and European monastic medicine as a digestive restorative.",
            "A quarter cup each of raw apple cider vinegar and raw honey was poured over the herbs, the jar sealed and shaken to combine — a classical oxymel preservation method that kept the preparation viable at room temperature for several weeks.",
            "One tablespoon of the oxymel was administered in four ounces of warm water twice daily — before the morning meal and before the evening meal — following the Hippocratic tradition of using bitter and pungent preparations as pre-meal digestive primers."
        ],
        duration: 21,
        disclaimer: "Garlic thins the blood. If you take warfarin, aspirin, or anticoagulant medications, consult your doctor before this protocol. Raw ACV must always be diluted as directed — undiluted vinegar erodes tooth enamel over time. Rinse your mouth after each dose.",
        citations: [
            RemedyCitation(
                text: "Hippocrates. On the Nature of Man. Circa 400 BCE. Collected in Hippocratic Writings. Penguin Classics, 1983.",
                url: "https://archive.org/details/hippocraticwriti00lloy"
            ),
            RemedyCitation(
                text: "Rivlin, R.S. Historical perspective on the use of garlic. J Nutr. 2001;131(3):951S–954S.",
                url: "https://pubmed.ncbi.nlm.nih.gov/11238798/"
            )
        ]
    )

    static let blackWalnutOregano = Remedy(
        name: "Black Walnut & Oregano Protocol",
        origin: "European Herbalism · Greece",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🌰",
        color: "#1A60A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Black walnut hull tincture",
                what: "A tincture made from the green outer hull of Juglans nigra — the black walnut tree. The hull contains juglone, a naphthoquinone compound with potent antifungal and antimicrobial properties. Used by European monastic healers and referenced by Hildegard von Bingen in the 12th century.",
                why: "Juglone disrupts the energy metabolism of pathogens and fungi in the gut, addressing microbial imbalances that are often the hidden driver of intense sugar cravings.",
                whereToBuy: "Health food stores or verified botanical distributors. Always purchase as a standardized tincture — never use raw green hulls directly (caustic and staining).",
                safety: "Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use. Use only standardized tinctures, not raw hull preparations. Do not exceed the stated dose."
            ),
            IngredientDetail(
                name: "Oil of oregano (Origanum vulgare)",
                what: "A concentrated essential oil from Mediterranean oregano, standardized to contain at least 70% carvacrol — a phenolic compound with broad-spectrum antimicrobial activity that disrupts the cell membranes of pathogenic bacteria, yeasts, and fungi.",
                why: "Carvacrol is one of the most potent natural antimicrobials known, active against a wide range of pathogens while showing selective preservation of beneficial Lactobacillus strains in research.",
                whereToBuy: "Health food stores. Look for Mediterranean origin oil with ≥70% carvacrol — North American oregano has much lower carvacrol content.",
                safety: "Very potent — must be diluted in olive oil before ingestion as directed. May reduce iron absorption; take with food. Avoid during pregnancy. Not for prolonged use beyond 14 days."
            ),
            IngredientDetail(
                name: "Clove powder",
                what: "Ground dried flower buds of Syzygium aromaticum, containing eugenol — a compound with documented antifungal activity, particularly against Candida species, and biofilm-disrupting properties.",
                why: "Addresses the afternoon sugar craving pattern that often signals yeast or bacterial imbalances in the lower digestive tract, where clove's antifungal action is most needed.",
                whereToBuy: "Any grocery store.",
                safety: "Safe at culinary doses. Clove essential oil is unsafe for internal use in concentrated amounts."
            ),
            IngredientDetail(
                name: "Wormwood tincture",
                what: "A tincture of Artemisia absinthium — European wormwood, distinct from Chinese Qing Hao. Contains absinthin and artabsin, which have bitter tonic and antimicrobial properties documented in Paracelsus's 16th-century writings on intestinal purification.",
                why: "Provides bitter tonic action that disrupts the dysbiotic gut environment supporting pathogenic overgrowth, completing the classical European three-herb purge cycle with black walnut and oregano.",
                whereToBuy: "Health food stores or verified botanical distributors. Purchase as a standardized tincture for controlled dosing.",
                safety: "Contains thujone — strictly do not exceed 20 drops as directed. Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use. Not for use by those with epilepsy or taking epilepsy medications."
            ),
            IngredientDetail(
                name: "Probiotic-rich kefir or yogurt",
                what: "A fermented dairy product containing live cultures of Lactobacillus and Bifidobacterium species — beneficial bacteria that colonize the gut and competitively exclude pathogens.",
                why: "Replenishes and restores beneficial gut flora after the antimicrobial herbs have cleared the way — this is the essential final step that turns a purge into a full restoration protocol.",
                whereToBuy: "Any grocery store. Look for 'live and active cultures' on the label. Plain, unsweetened varieties only — sugar feeds the pathogenic organisms you are addressing.",
                safety: "Those with dairy intolerance may use coconut kefir, available at health food stores. Always use plain, unsweetened varieties."
            )
        ],
        desc: "Used by European monastic healers and documented in Paracelsus's writings on purification, black walnut hull — rich in juglone — combined with oregano's carvacrol creates a powerful protocol for addressing sugar cravings linked to microbial imbalances. This formula follows the classical European three-herb purge cycle.",
        steps: [
            "In the European monastic herbal tradition, black walnut hull tincture was administered as twenty drops in four ounces of water each morning before food — the empty stomach timing considered essential to allow direct contact with the intestinal environment.",
            "Two to three drops of oil of oregano were combined with one teaspoon of olive oil and held briefly under the tongue before swallowing — a method Paracelsus-era practitioners used to maximize absorption of volatile aromatic compounds through the sublingual mucosa.",
            "A small pinch of clove powder in warm water was taken with the midday meal to address afternoon digestive irregularities — timing aligned with the traditional European understanding that digestive activity diminishes after noon and requires carminative support.",
            "Each day concluded with half a cup of plain kefir or unsweetened yogurt — a restorative final step that European healers considered essential to complete the classical purge-and-replenish cycle."
        ],
        duration: 14,
        disclaimer: "This is a potent antimicrobial protocol. Do not exceed the stated doses — particularly for wormwood tincture (no more than 20 drops) and oil of oregano. If you are pregnant, have epilepsy, or take immunosuppressant medications, do not use this protocol without consulting your doctor. Always complete the probiotic step daily — the kefir or yogurt is not optional.",
        citations: [
            RemedyCitation(
                text: "Paracelsus (Philippus Aureolus Theophrastus Bombastus von Hohenheim). Archidoxa. 1570 CE. Discussed in Webster, C. Paracelsus: Medicine, Magic and Mission. Yale University Press, 2008.",
                url: "https://archive.org/details/archidoxis00para"
            ),
            RemedyCitation(
                text: "Nostro, A. et al. Susceptibility of methicillin-resistant staphylococci to oregano essential oil, carvacrol and thymol. FEMS Microbiol Lett. 2007;272(2):179–183.",
                url: "https://pubmed.ncbi.nlm.nih.gov/17490428/"
            )
        ]
    )

    static let valerianPassionflower = Remedy(
        name: "Valerian & Passionflower Evening Tonic",
        origin: "European Herbalism · Europe",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🌙",
        color: "#1A60A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Valerian root (dried or tincture)",
                what: "Root of Valeriana officinalis — one of the most widely studied sleep herbs in Western botanical medicine. Valerenic acid inhibits GABA-transaminase, the enzyme that breaks down the calming neurotransmitter GABA, extending its calming effect without the dependency associated with pharmaceutical sedatives.",
                why: "Addresses the neurological root of sleep difficulties by enhancing GABAergic tone — the brain's primary 'braking system' that quiets racing thoughts and helps initiate sleep onset.",
                whereToBuy: "Health food stores or verified botanical distributors. Available as dried root or tincture — tincture works faster.",
                safety: "May cause vivid dreams; drowsiness may persist into the morning at high doses. Do not combine with alcohol, prescription sedatives, or benzodiazepines — additive sedative effect."
            ),
            IngredientDetail(
                name: "Passionflower leaf",
                what: "Leaves of Passiflora incarnata — a native North American vine used by Indigenous peoples and later adopted into European herbal medicine. Chrysin and orientin bind GABA-A receptors, reducing anxiety and helping the mind 'let go' at bedtime.",
                why: "Particularly effective for sleep difficulties driven by an overactive, anxious mind — the type that replays the day's events or generates worry at night. Passionflower quiets this without the next-morning grogginess of stronger sedatives.",
                whereToBuy: "Health food stores or verified botanical distributors.",
                safety: "Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use — may cause uterine contractions. Mild sedative — do not drive or operate machinery after use."
            ),
            IngredientDetail(
                name: "Lemon balm",
                what: "Leaves of Melissa officinalis — a fragrant herb in the mint family. Rosmarinic acid inhibits GABA-transaminase (same mechanism as valerian) and reduces cortisol. Used by medieval physicians including Paracelsus for calming the nervous system.",
                why: "Reduces the cortisol elevation that prevents sleep in people whose stress response is activated in the evening — commonly experienced as 'tired but wired' before bed.",
                whereToBuy: "Health food stores, often sold fresh or as dried herb. Also easily grown at home.",
                safety: "May mildly suppress thyroid hormone activity — use with caution if you have hypothyroidism or take thyroid medication."
            ),
            IngredientDetail(
                name: "Lavender flowers",
                what: "Dried flowers of Lavandula angustifolia — whose volatile compounds linalool and linalyl acetate have demonstrated anxiolytic effects equivalent to low-dose lorazepam in clinical studies, without dependency or cognitive impairment.",
                why: "Added as a tincture after steeping to preserve the volatile aromatic compounds that would evaporate in boiling water. Both the ingested compounds and the scent itself contribute to the calming effect.",
                whereToBuy: "Health food stores and online. Ensure you purchase culinary-grade dried lavender (not decorative or cosmetic grade).",
                safety: "Use only culinary-grade or food-grade lavender. Lavender essential oil is NOT safe for internal use — this formula uses dried flowers or tincture only."
            ),
            IngredientDetail(
                name: "Chamomile",
                what: "Flowers of Matricaria chamomilla — the most widely consumed herbal sleep aid in the world. Apigenin binds benzodiazepine receptors mildly, promoting gentle relaxation without sedation. Hildegard von Bingen prescribed chamomile in the 12th century for 'all inner disorders.'",
                why: "Provides a gentle, approachable base layer of relaxation that makes the stronger herbs in this formula easier to tolerate, and adds direct GABA-modulating support.",
                whereToBuy: "Any grocery store. Look for whole chamomile flowers (not powdered) for highest apigenin content.",
                safety: "Avoid if you have a known ragweed allergy (same botanical family). Otherwise one of the safest herbal medicines available."
            )
        ],
        desc: "Hildegard von Bingen prescribed valerian for 'those whose mind is troubled at night' in her 12th-century Physica. This evening tonic combines valerian's GABA-potentiating properties with passionflower, lemon balm, and lavender in a classic European sleep formula — calming the nervous system without dependency.",
        steps: [
            "European herbalists prepared this evening blend by combining one teaspoon each of dried valerian root and passionflower leaf with half a teaspoon each of dried lemon balm and chamomile flowers in a ceramic vessel — ceramic being the traditional preference for delicate nervine infusions.",
            "Two cups of freshly boiled water were poured over the herbs and the vessel was immediately covered and left to steep for fifteen minutes — the covering considered essential to prevent the volatile aromatic compounds from escaping with the steam.",
            "After straining through fine mesh, four drops of culinary-grade lavender tincture — or a single drop of food-grade lavender oil — were stirred in off the heat, preserving the volatile linalool compounds that would otherwise evaporate if added to a hot liquid.",
            "The full cup was consumed warm, forty-five minutes before the intended bedtime, in a quiet and dimly lit space — European physicians prescribed both the formula and the environmental conditions as equal parts of the therapeutic ritual."
        ],
        duration: 14,
        disclaimer: "Do not combine this tonic with alcohol, prescription sleeping pills, or benzodiazepines — the combination creates an additive sedative effect. Passionflower is not safe during pregnancy. If you have hypothyroidism, speak with your doctor before using lemon balm. Use culinary-grade lavender only — lavender essential oil is not safe for internal use.",
        citations: [
            RemedyCitation(
                text: "Hildegard von Bingen. Physica. Circa 1150 CE. Translated by Throop, P. Healing Arts Press, 1998.",
                url: "https://archive.org/details/hildegard-von-bingen-physica"
            ),
            RemedyCitation(
                text: "Bent, S. et al. Valerian for sleep: a systematic review and meta-analysis. Am J Med. 2006;119(12):1005–1012.",
                url: "https://pubmed.ncbi.nlm.nih.gov/17145239/"
            )
        ]
    )

    // MARK: - African Herbalism

    static let moringaBaobabTonic = Remedy(
        name: "Moringa Leaf & Baobab Vitality Tonic",
        origin: "African Herbalism · West Africa",
        tradition: "African Herbalism",
        tid: "african",
        icon: "🌾",
        color: "#4A7C45",
        ingredientDetails: [
            IngredientDetail(
                name: "Moringa leaf powder",
                what: "Dried leaves of Moringa oleifera — the 'miracle tree' used for centuries across West and East Africa. Gram for gram: more iron than spinach, more calcium than milk, more vitamin C than oranges, and a complete essential amino acid profile — rare in any plant.",
                why: "Addresses the micronutrient deficiencies — particularly iron — that are among the most common and overlooked drivers of chronic fatigue in women. Provides the nutritional foundation the body needs to produce sustained energy.",
                whereToBuy: "Health food stores or online via Organic India or Kuli Kuli. Look for raw, cold-dried moringa — not heat-processed, which destroys heat-sensitive nutrients.",
                safety: "Generally very safe. May interact with thyroid medication at high doses. Moringa leaves are safe during pregnancy; moringa root and bark are not — avoid those parts."
            ),
            IngredientDetail(
                name: "Baobab fruit powder",
                what: "The tart, chalky powder from the fruit of Adansonia digitata — the 'Tree of Life' revered across Sub-Saharan Africa. Contains more vitamin C than oranges by weight, along with significant prebiotic fiber, magnesium, and potassium.",
                why: "Vitamin C dramatically enhances iron absorption from moringa — a critical pairing, since plant-based iron (non-heme) requires vitamin C to be bioavailable. The prebiotic fiber also supports gut health, which underlies sustained energy and immunity.",
                whereToBuy: "Health food stores or online via Aduna or Mighty Baobab. Increasingly available in larger grocery stores.",
                safety: "Very safe. The high fiber content may cause initial digestive adjustment — start with a half dose for the first 3 days."
            ),
            IngredientDetail(
                name: "Fresh ginger root",
                what: "Warming, circulation-stimulating rhizome whose gingerols and shogaols improve peripheral blood flow and digestive absorption of nutrients.",
                why: "Stimulates circulation and digestive secretions, ensuring the formula's micronutrients are fully absorbed and distributed — particularly important when addressing fatigue-linked micronutrient deficiencies.",
                whereToBuy: "Any grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Cinnamon",
                what: "Ceylon cinnamon (Cinnamomum verum) — a warming spice that stabilizes blood sugar through insulin-sensitizing compounds.",
                why: "Blood sugar instability is one of the most common but underrecognized contributors to fatigue — particularly the mid-afternoon energy crash. Ceylon cinnamon prevents the glucose fluctuations that drive this pattern.",
                whereToBuy: "Health food stores. Specify Ceylon cinnamon, not cassia (the common grocery store variety).",
                safety: "Use Ceylon cinnamon for extended protocols — cassia contains coumarin that can affect the liver in large amounts over time."
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "Unprocessed honey used across African traditional medicine as the primary medicine delivery vehicle. Provides easily digestible natural sugars, active enzymes, and prebiotic compounds.",
                why: "In West African healing tradition, honey is the essential carrier that makes bitter or earthy herbal formulas palatable and enhances absorption. Provides a gentle, non-spike energy boost as a complement to moringa's sustained nutrition.",
                whereToBuy: "Health food stores or farmers markets. Raw and unfiltered.",
                safety: "Not for infants under 12 months."
            )
        ],
        desc: "Moringa oleifera — the 'miracle tree' of African traditional medicine — carries more iron than spinach and more vitamin C than oranges. Paired with baobab's prebiotic richness, this tonic addresses the nutritional root causes of chronic fatigue: iron deficiency, micronutrient gaps, and the blood sugar instability that drives daily energy crashes.",
        steps: [
            "West African healers who used this nutrient-rich tonic began by warming two cups of water to just below boiling, adding two slices of fresh ginger root and simmering gently for five minutes to extract the warming compounds.",
            "The water was removed from heat and one teaspoon each of moringa leaf powder and baobab fruit powder were whisked in until fully dissolved — a technique traditional practitioners emphasized, as boiling temperatures were understood to degrade moringa's heat-sensitive nutritional content.",
            "A pinch of Ceylon cinnamon was added, and the preparation was steeped for three minutes — a brief resting period that West African healing tradition held was necessary for the botanical constituents to fully integrate.",
            "One teaspoon of raw honey was stirred in as the final step, and the tonic was consumed each morning within thirty minutes of waking — the traditional timing that aligned with the body's morning absorption window on an empty, primed digestive system."
        ],
        duration: 21,
        disclaimer: "Moringa leaf powder is safe for most people, but if you take thyroid medication, consult your doctor before starting — moringa can influence thyroid function at high doses. Moringa leaves are safe during pregnancy; avoid moringa bark or root preparations. Results from this protocol are typically noticeable within 7–10 days of consistent use.",
        citations: [
            RemedyCitation(
                text: "Fahey, J.W. Moringa oleifera: A review of the medical evidence for its nutritional, therapeutic, and prophylactic properties. Trees for Life Journal. 2005;1:5.",
                url: "https://www.moringanews.org/documents/moringa_review_Fahey.pdf"
            ),
            RemedyCitation(
                text: "Muthai, K.U. et al. Nutritional variation in Moringa oleifera grown under different conditions. Food Sci Nutr. 2017;5(6):1174–1189.",
                url: "https://pubmed.ncbi.nlm.nih.gov/29188008/"
            )
        ]
    )

    static let rooibosBuchuBrew = Remedy(
        name: "Rooibos & Buchu Skin Brew",
        origin: "African Herbalism · South Africa",
        tradition: "African Herbalism",
        tid: "african",
        icon: "🍵",
        color: "#4A7C45",
        ingredientDetails: [
            IngredientDetail(
                name: "Rooibos (red bush) leaf",
                what: "Dried leaves and stems of Aspalathus linearis — endemic to South Africa's Cederberg region, used by the indigenous Khoikhoi people for centuries. Contains aspalathin — a unique antioxidant found in no other plant on Earth — along with nothofagin and dozens of anti-inflammatory flavonoids.",
                why: "Aspalathin has documented cortisol-modulating properties that reduce stress-driven skin flare-ups — one of the most common but underaddressed triggers for chronic skin irritation. Completely caffeine-free, making it safe for daily long-term use.",
                whereToBuy: "Health food stores, specialty tea shops, or online. Organic loose-leaf rooibos preferred over bagged.",
                safety: "Extremely safe; one of the most studied herbal teas in the world. Very rarely associated with elevated liver enzymes in unusually high consumption — culinary amounts are fully safe."
            ),
            IngredientDetail(
                name: "Buchu leaf",
                what: "Leaves of Agathosma betulina — a fynbos (Cape scrub) shrub used medicinally by the Khoikhoi and Xhosa peoples of South Africa for over 300 years before European contact. Rich in diosphenol and flavonoids with anti-inflammatory and diuretic properties.",
                why: "Supports the kidneys and lymphatic elimination pathways — the drainage channels whose congestion the Khoikhoi tradition identifies as the root of skin irritation. Also provides direct anti-inflammatory compounds that reduce dermal inflammation.",
                whereToBuy: "Health food stores or verified botanical distributors or organic food repositories.",
                safety: "Generally safe. Traditional literature suggests caution during pregnancy. Consult a qualified healthcare provider before use. Not for long-term use by those with kidney disease."
            ),
            IngredientDetail(
                name: "Honeybush leaf",
                what: "Dried leaves of Cyclopia species — another plant endemic to South Africa's fynbos. Contains mangiferin and hesperidin with antioxidant capacity greater than rooibos, and documented phytoestrogenic activity.",
                why: "Phytoestrogenic compounds in honeybush support skin hydration and elasticity — particularly relevant for the hormonal skin changes experienced by women in the 28–45 age range. Synergizes deeply with rooibos.",
                whereToBuy: "Health food stores or online. Often sold blended with rooibos.",
                safety: "Due to phytoestrogenic properties, consult your doctor if you have hormone-sensitive conditions (PCOS, endometriosis, estrogen-receptor positive conditions)."
            ),
            IngredientDetail(
                name: "Lemon juice",
                what: "Fresh citrus juice providing vitamin C — the rate-limiting cofactor for collagen synthesis — and citric acid that aids active compound extraction from the dried herbs.",
                why: "Vitamin C is required for the production of collagen, the structural protein that gives skin integrity and resilience. Addressing vitamin C status through food-form sources has documented benefits for skin repair.",
                whereToBuy: "Any grocery store. Fresh-squeezed only — bottled juice is heated, losing most vitamin C.",
                safety: "Rinse your mouth after drinking to protect tooth enamel."
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "Unprocessed honey whose antimicrobial and anti-inflammatory compounds — hydrogen peroxide, defensin-1, methylglyoxal — reach systemic circulation when consumed internally.",
                why: "Internal consumption of raw honey reduces markers of systemic inflammation that underlie chronic skin conditions. The traditional South African healing model treats skin issues as whole-body rather than local problems.",
                whereToBuy: "Health food stores or farmers markets. Raw and unfiltered.",
                safety: "Not for infants under 12 months."
            )
        ],
        desc: "The Khoikhoi people of South Africa used rooibos — containing aspalathin, found in no other plant on Earth — to address skin conditions and inflammation. This brew pairs it with buchu, a fynbos herb used medicinally for centuries before European contact, to address skin irritation through the elimination pathways rather than at the surface.",
        steps: [
            "Among the Khoikhoi people of the Cape region, rooibos was prepared by bringing water to just below boiling — a careful temperature distinction that South African herbalists maintained to preserve the heat-sensitive aspalathin compounds.",
            "One tablespoon of loose rooibos and one teaspoon of buchu leaf were added, the vessel covered, and the herbs steeped for ten minutes — the covered steeping being essential in traditional practice to capture the aromatic diosphenol compounds of the buchu leaf.",
            "One teaspoon of honeybush leaf was included in the final steeping stage; the brew was then strained and allowed to cool to a comfortable drinking temperature — the three-herb combination reflecting the classical fynbos healing tradition of layering complementary botanicals.",
            "The juice of half a lemon and one teaspoon of raw honey were stirred in last, and the brew was consumed once daily in the morning — morning use aligning with the Khoikhoi tradition of using elimination-supporting herbs before the body's daily food processing began."
        ],
        duration: 14,
        disclaimer: "Honeybush contains phytoestrogenic compounds — consult your doctor before starting if you have a history of hormone-sensitive conditions. Buchu is not recommended during pregnancy. If skin symptoms are accompanied by fever, rapidly spreading redness, or difficulty breathing, seek medical attention promptly.",
        citations: [
            RemedyCitation(
                text: "Joubert, E. & de Beer, D. Rooibos (Aspalathus linearis) beyond the farm gate: From herbal tea to potential phytopharmaceutical. S Afr J Bot. 2011;77(4):869–886.",
                url: "https://www.sciencedirect.com/science/article/pii/S0254629911001421"
            ),
            RemedyCitation(
                text: "Viljoen, A. et al. Buchu — Agathosma betulina and Agathosma crenulata (Rutaceae): A review of the historical, traditional uses and medicinal properties. J Ethnopharmacol. 2006;119(3):413–419.",
                url: "https://pubmed.ncbi.nlm.nih.gov/16973314/"
            )
        ]
    )

    static let grainsOfParadiseTonic = Remedy(
        name: "Grains of Paradise Digestive Tonic",
        origin: "African Herbalism · West Africa",
        tradition: "African Herbalism",
        tid: "african",
        icon: "🌶",
        color: "#4A7C45",
        ingredientDetails: [
            IngredientDetail(
                name: "Grains of paradise (Aframomum melegueta)",
                what: "Seeds of a West African plant in the ginger family — historically so prized they gave the 'Grain Coast' of West Africa (modern Liberia and Ghana) its name. Contains paradol, shogaol, and gingerol-related compounds that activate TRPV1 and TRPV3 thermoreceptors in the digestive tract.",
                why: "Paradol stimulates digestive peristalsis and reduces intestinal gas through thermoreceptor activation — a distinct and complementary mechanism to black pepper or ginger. Provides the digestive 'fire' celebrated in West African healing traditions as the key to gut harmony.",
                whereToBuy: "Specialty spice shops, West African grocery stores, or online via Burlap & Barrel or Kalustyan's. Increasingly stocked in upscale grocery stores.",
                safety: "Safe at culinary and mild therapeutic doses. Avoid in high amounts during pregnancy."
            ),
            IngredientDetail(
                name: "Fresh ginger root",
                what: "The foundational digestive herb of African and global traditional medicine. Warming, carminative, and anti-nausea through its gingerols and shogaols.",
                why: "Synergizes with grains of paradise through complementary TRPV1 activation — both herbs stimulate the same digestive warming receptors through different compounds, creating a broader, more sustained carminative effect.",
                whereToBuy: "Any grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Fennel seeds",
                what: "Carminative seeds of Foeniculum vulgare — their volatile oils (trans-anethole, fenchone) relax intestinal smooth muscle and prevent gas formation.",
                why: "Prevents the discomfort that can occur as warming herbs increase digestive motility. Ensures the protocol remains comfortable while the gut adjusts to more active peristaltic movement.",
                whereToBuy: "Any grocery store.",
                safety: "Safe at culinary doses. Avoid large therapeutic amounts during pregnancy."
            ),
            IngredientDetail(
                name: "Lemon juice",
                what: "Fresh citrus providing citric acid and vitamin C — the sour taste directly activates the vagal digestive reflex, stimulating digestive secretions before they are needed.",
                why: "The sour taste triggers the same digestive preparation reflex as bitters — priming the stomach, liver, and pancreas for efficient digestion. A natural digestive aperitif element.",
                whereToBuy: "Any grocery store. Fresh-squeezed only.",
                safety: "Dilute well and rinse mouth after."
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "The harmonizing sweetener used across West African healing traditions to balance pungent and warming herb formulas, preventing over-stimulation of the digestive lining.",
                why: "Moderates the heat of grains of paradise and ginger, making the formula comfortable for daily use across the full 14-day protocol. Also provides prebiotic sugars that feed beneficial gut bacteria.",
                whereToBuy: "Health food stores or farmers markets.",
                safety: "Not for infants under 12 months."
            )
        ],
        desc: "Grains of paradise — so prized in West African trade history they named the Grain Coast — are seeds in the ginger family used by healers across Nigeria, Senegal, and Ghana to kindle digestive fire and resolve bloating. This tonic activates the same digestive thermoreceptors as ginger, but through a distinct compound pathway that makes the combination significantly more potent.",
        steps: [
            "West African healers of the Grain Coast tradition began this preparation by lightly crushing one teaspoon of grains of paradise with a mortar and pestle — the crushing, not grinding, releasing the aromatic volatile oils while preserving the structure of the active paradol compounds.",
            "The cracked seeds were combined with two slices of fresh ginger and one teaspoon of fennel seeds in a saucepan with two cups of water, then brought to a low simmer — gradual heat being preferred over sudden boiling in traditional West African preparation.",
            "The blend was decocted gently for ten minutes, then removed from heat and allowed to steep for five additional minutes — a resting period that Ghanaian and Senegalese healers held was necessary for the compounds to fully meld.",
            "After straining, the juice of half a lemon and one teaspoon of raw honey were added, and the tonic was consumed warm twenty minutes before the main meal — a pre-meal timing that West African digestive tradition considered essential for priming the body's absorption response."
        ],
        duration: 14,
        disclaimer: "This formula is warming and activating. Avoid if you have GERD, active acid reflux, or peptic ulcers — warming digestive herbs can aggravate these conditions. Grains of paradise should not be consumed in high amounts during pregnancy. If you experience significant heartburn or digestive pain, discontinue and consult a practitioner.",
        citations: [
            RemedyCitation(
                text: "Dzeufiet, P.D. et al. Hypoglycemic effect of Aframomum melegueta (Roscoe) K. Schum seeds in streptozotocin-diabetic rats. Afr J Tradit Complement Altern Med. 2012;10(1):71–79.",
                url: "https://pubmed.ncbi.nlm.nih.gov/24082346/"
            ),
            RemedyCitation(
                text: "Iwu, M.M. Handbook of African Medicinal Plants, 2nd ed. CRC Press, 2014.",
                url: "https://www.routledge.com/Handbook-of-African-Medicinal-Plants/Iwu/p/book/9781466585911"
            )
        ]
    )

    // MARK: - Persian Medicine (additional)

    static let blackSeedElixir = Remedy(
        name: "Black Seed (Habbatus Sauda) Elixir",
        origin: "Persian Medicine · Iran & Arabia",
        tradition: "Persian Medicine",
        tid: "persian",
        icon: "🖤",
        color: "#7B35A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Nigella sativa seeds or cold-pressed oil",
                what: "Seeds of Nigella sativa — called Habbatus Sauda in Arabic and Siah Daneh in Persian. The most documented plant in both Ibn Sina's Canon of Medicine and Islamic prophetic tradition. The active compound thymoquinone has been the subject of over 1,000 published scientific studies examining its anti-inflammatory, antioxidant, and immune-modulating properties.",
                why: "Thymoquinone inhibits both the COX and 5-LOX inflammatory enzyme pathways simultaneously — dual-pathway action that is particularly effective for joint inflammation, which involves both pathways. Ibn Sina prescribed it specifically for joint conditions and 'heaviness of the limbs.'",
                whereToBuy: "Middle Eastern grocery stores, health food stores, or online via Amazing Herbs (a well-researched brand). Cold-pressed oil is preferred over whole seeds for this formula — more bioavailable thymoquinone.",
                safety: "Generally very safe. May lower blood sugar — caution if diabetic or on blood sugar medication. May interact with blood thinners at therapeutic doses."
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "In Persian and Islamic medicine, honey (Asal) is the primary prescribed vehicle for black seed administration — documented in both Ibn Sina's Canon and in hadith literature as the ideal carrier for Habbatus Sauda.",
                why: "Honey enhances thymoquinone absorption and provides its own anti-inflammatory compounds. The traditional combination of black seed and honey is the oldest documented use of Nigella sativa as medicine.",
                whereToBuy: "Health food stores or farmers markets. Raw and unfiltered.",
                safety: "Not for infants under 12 months."
            ),
            IngredientDetail(
                name: "Apple cider vinegar",
                what: "In Persian medicine, vinegar-honey preparations (Sikanjabeen) are a classical formulation for reducing inflammation and supporting liver metabolism. ACV provides acetic acid and live culture.",
                why: "Provides the acidic Sikanjabeen base of classical Persian medicine that enhances the solubility and absorption of fat-soluble thymoquinone, and contributes its own anti-inflammatory support.",
                whereToBuy: "Any grocery store. Raw, unfiltered with the mother.",
                safety: "Always dilute as directed. Not for those with peptic ulcers or GERD."
            ),
            IngredientDetail(
                name: "Turmeric",
                what: "Anti-inflammatory rhizome whose curcumin also inhibits NF-kB — the same master inflammatory transcription factor that thymoquinone targets, through complementary binding sites.",
                why: "Curcumin and thymoquinone create synergistic anti-inflammatory coverage by inhibiting NF-kB from different binding sites simultaneously — broader suppression of the inflammatory signaling cascade than either compound alone.",
                whereToBuy: "Any grocery store or Indian grocery store.",
                safety: "High doses may interact with blood-thinning medications."
            ),
            IngredientDetail(
                name: "Black pepper",
                what: "Piperine dramatically increases the bioavailability of both thymoquinone and curcumin by inhibiting their rapid hepatic metabolism.",
                why: "Without piperine, both thymoquinone and curcumin are rapidly cleared by the liver before reaching systemic circulation. Even a small pinch of black pepper extends their effective duration in the body significantly.",
                whereToBuy: "Any grocery store.",
                safety: nil
            )
        ],
        desc: "Ibn Sina wrote in the Canon of Medicine that black seed 'stimulates the body's energy and helps recovery from fatigue and dispiritedness.' Habbatus Sauda — Nigella sativa — has been the subject of over 1,000 modern studies, with thymoquinone showing dual COX and 5-LOX anti-inflammatory inhibition particularly relevant for joint mobility and muscular ease.",
        steps: [
            "In classical Persian and Islamic medicine, the black seed elixir was prepared by combining one teaspoon of cold-pressed Nigella sativa oil (or freshly ground seeds) with one tablespoon of raw honey — the honey-and-black-seed pairing being the oldest documented use of Habbatus Sauda as medicine.",
            "One teaspoon of apple cider vinegar, half a teaspoon of turmeric, and a pinch of black pepper were added to the cup — a formulation Persian physicians called Sikanjabeen-el-Aswad, combining the classical vinegar-honey Sikanjabeen base with the most revered therapeutic seed in the Islamic pharmacopeia.",
            "Two ounces of warm water were added last and the formula stirred until fully combined — the warm water serving both as a volume carrier and as a gentle warming medium consistent with Persian Unani principles of supporting digestion.",
            "The elixir was consumed each morning on an empty stomach, at least twenty minutes before any food was taken — a timing prescribed by Ibn Sina in the Canon of Medicine as optimal for Habbatus Sauda's systemic absorption."
        ],
        duration: 21,
        disclaimer: "Black seed (Nigella sativa) may lower blood sugar — if you are diabetic or take blood sugar medication, monitor your levels carefully when starting this protocol. May interact with blood-thinning medications at therapeutic doses. If you are on any prescription medication, consult your doctor before combining. Raw black seed oil has a strong, pungent flavor — this is normal.",
        citations: [
            RemedyCitation(
                text: "Randhawa, M.A. & Alghamdi, M.S. Anticancer activity of Nigella sativa (black seed): A review. Am J Chin Med. 2011;39(6):1075–1091.",
                url: "https://pubmed.ncbi.nlm.nih.gov/22083982/"
            ),
            RemedyCitation(
                text: "Ibn Sina (Avicenna). Al-Qanun fi al-Tibb (Canon of Medicine), Book II — Habbatus Sauda (Black Seed). 1025 CE.",
                url: "https://archive.org/details/canonofmedicinev00avic"
            )
        ]
    )

    static let fenugreekChamomileTonic = Remedy(
        name: "Fenugreek & Chamomile Mood Tonic",
        origin: "Persian Medicine · Iran",
        tradition: "Persian Medicine",
        tid: "persian",
        icon: "🌼",
        color: "#7B35A0",
        ingredientDetails: [
            IngredientDetail(
                name: "Fenugreek seeds",
                what: "Seeds of Trigonella foenum-graecum — one of the oldest documented medicinal plants, found in Egyptian tombs and referenced by Hippocrates. Ibn Sina prescribed it for women's health, digestion, and 'sadness of the heart.' Contains diosgenin (a phytosterol precursor with phytoestrogenic activity) and 4-hydroxyisoleucine (a unique amino acid that improves insulin sensitivity and serotonin precursor availability).",
                why: "Diosgenin's phytoestrogenic activity helps regulate the hormonal fluctuations that drive mood instability in women — particularly in the luteal phase and perimenopause. 4-hydroxyisoleucine enhances serotonin precursor uptake, providing mood-brightening support through a metabolic pathway.",
                whereToBuy: "Indian grocery stores, Middle Eastern grocery stores, or any grocery store (often in the spice aisle as whole seeds).",
                safety: "Avoid at therapeutic doses during pregnancy — fenugreek has traditionally been used to induce labor. May lower blood sugar. Those with hormone-sensitive conditions should consult their doctor before starting."
            ),
            IngredientDetail(
                name: "Dried chamomile flowers",
                what: "Flowers of Matricaria chamomilla — used in Persian medicine for centuries as a nervine and digestive herb. Apigenin binds GABA-A receptors (reducing anxiety) and has been shown to bind serotonin receptors (supporting mood stability). One of the most studied anxiolytic herbs in modern pharmacology.",
                why: "Provides immediate, gentle anxiolytic action that complements fenugreek's longer-acting hormonal support — addressing both the immediate experience of mood instability and the underlying hormonal pattern driving it.",
                whereToBuy: "Any grocery store or health food store. Whole dried flowers preferred over powdered.",
                safety: "Avoid if allergic to ragweed (same family). Otherwise extremely safe and gentle."
            ),
            IngredientDetail(
                name: "Rose water",
                what: "Steam-distilled hydrosol from Rosa damascena — Iran's Kashan region produces the world's most prized Damask rose water, used for over 1,000 years in Persian Unani medicine to 'strengthen the heart' and calm emotional agitation. Contains citronellol and geraniol with documented anxiolytic properties.",
                why: "The aromatic experience of rose water is part of its therapeutic action — olfactory receptor activation of the limbic system (the brain's emotional center) by rose fragrance has documented mood-modulating effects in human studies. A rare example of a treatment where taste and scent are both medicine.",
                whereToBuy: "Middle Eastern grocery stores, health food stores, or online. Must be food-grade, not cosmetic.",
                safety: "Ensure food-grade purchase. Cosmetic rose water may contain additives not safe for internal use."
            ),
            IngredientDetail(
                name: "Cardamom",
                what: "Aromatic pods of Elettaria cardamomum — described by Ibn Sina as a 'gladdener of the heart' and used across Persian medicine as a digestive nervine that addresses the gut-brain connection underlying emotional health.",
                why: "Many mood disorders have a significant gastrointestinal component — cardamom's dual action on the digestive tract and the nervous system makes it ideally suited for mood formulas that also need to address the physical symptoms (digestive tension, nausea) that accompany anxiety and low mood.",
                whereToBuy: "Any grocery store or Indian/Middle Eastern grocery store.",
                safety: nil
            ),
            IngredientDetail(
                name: "Raw honey",
                what: "In Persian and Unani medicine, honey is prescribed as the essential carrier that delivers nervine herbs into the 'subtle channels' (Lataif) that influence emotional experience. Also provides prebiotic substrate supporting the gut-brain axis.",
                why: "Enhances the palatability and absorption of fenugreek's bitter saponins — making it possible to maintain a daily therapeutic dose comfortably throughout the 21-day protocol.",
                whereToBuy: "Health food stores or farmers markets.",
                safety: "Not for infants under 12 months. Add after cooling below 40°C / 104°F."
            )
        ],
        desc: "Ibn Sina prescribed fenugreek for 'sadness of the heart' in the Canon of Medicine — its diosgenin content provides phytoestrogenic regulation of the hormonal mood fluctuations that affect many women. Paired with Persian chamomile and Damask rose water, this tonic addresses both the underlying hormonal pattern and the immediate experience of emotional instability.",
        steps: [
            "In Persian medicine, fenugreek seeds were always prepared with an overnight soak in cold water — a practice that traditional healers recognized as softening the outer seed coat and initiating enzymatic activation of the phytoestrogenic compounds before decoction.",
            "The soaked and rinsed seeds were simmered in two cups of water for ten minutes; the heat was then removed and one tablespoon of dried chamomile flowers and a quarter teaspoon of cardamom were added and steeped for eight minutes — the gentle, off-heat steeping preserving chamomile's volatile apigenin.",
            "After straining, the brew was allowed to cool slightly before one teaspoon of food-grade rose water was added — the rose water in Persian Unani tradition was always added after heat to preserve the volatile aromatic compounds central to its heart-calming action.",
            "One teaspoon of raw honey was stirred in as the final step, and the tonic was consumed each evening — evening use aligning with Persian medical tradition, which prescribed hormone-regulating botanicals in the late day to support the body's overnight restorative cycles."
        ],
        duration: 21,
        disclaimer: "Fenugreek has phytoestrogenic activity and mild blood-sugar-lowering effects. Do not use at therapeutic doses during pregnancy. If you have a hormone-sensitive condition (endometriosis, PCOS, estrogen-receptor positive cancers) or take blood sugar medication, consult your doctor before starting. This formula supports mood and is not a substitute for professional mental health care.",
        citations: [
            RemedyCitation(
                text: "Bhardwaj, S. et al. Antidepressant-like activity of Trigonella foenum-graecum seed extract in animal models of depression. Phytother Res. 2012;26(1):5–13.",
                url: "https://pubmed.ncbi.nlm.nih.gov/21560181/"
            ),
            RemedyCitation(
                text: "Ibn Sina (Avicenna). Al-Qanun fi al-Tibb (Canon of Medicine), Book II — Hulba (Fenugreek). 1025 CE.",
                url: "https://archive.org/details/canonofmedicinev00avic"
            )
        ]
    )

    // MARK: - Symptom → Remedy Mapping

    static let symptomMap: [String: [Remedy]] = [
        "Bloating & Gas": [triphalaGinger, wormwoodCloveTonic, grainsOfParadiseTonic],
        "Fatigue": [ashwagandhaGoldenMilk, moringaBaobabTonic],
        "Digestive Issues": [papayaSeedHoney, garlicThymeOxymel],
        "Skin Irritation": [neemTurmericTea, rooibosBuchuBrew],
        "Brain Fog": [brahmiGinkgoBrew],
        "Sugar Cravings": [blackWalnutOregano],
        "Joint Discomfort": [boswelliaTurmericPaste, blackSeedElixir],
        "Sleep Issues": [valerianPassionflower],
        "Appetite Loss": [agniStimulatingBitters],
        "Mood Changes": [saffronRhodiolaBlend, fenugreekChamomileTonic]
    ]

    static func remedies(for tid: String) -> [Remedy] {
        var seen = Set<String>()
        var result: [Remedy] = []
        for remedy in symptomMap.values.flatMap({ $0 }) where remedy.tid == tid {
            if seen.insert(remedy.name).inserted { result.append(remedy) }
        }
        return result
    }

    static func remedies(for symptoms: Set<String>) -> [Remedy] {
        var seen = Set<String>()
        var result: [Remedy] = []
        for symptom in symptoms {
            for remedy in symptomMap[symptom] ?? [] {
                if seen.insert(remedy.name).inserted {
                    result.append(remedy)
                }
            }
        }
        return result
    }
}
