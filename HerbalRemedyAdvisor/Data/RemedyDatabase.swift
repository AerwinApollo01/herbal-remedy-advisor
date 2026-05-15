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
        ingredients: ["Triphala powder", "Fresh ginger root", "Black pepper", "Honey", "Warm water"],
        desc: "A foundational Ayurvedic cleansing tonic combining the three fruits of Triphala — amalaki, bibhitaki, and haritaki — with warming ginger to stimulate Agni (digestive fire), eliminate Ama (toxins), and restore balance to all three doshas.",
        steps: [
            "Boil 2 cups of water and add 1 tsp Triphala powder and ½ tsp freshly grated ginger.",
            "Simmer on low heat for 10 minutes, then remove from heat and steep for 5 minutes.",
            "Strain into a cup, add a pinch of black pepper, and let cool to drinking temperature.",
            "Stir in 1 tsp raw honey and drink 30 minutes before bed each evening."
        ],
        duration: 21
    )

    static let ashwagandhaGoldenMilk = Remedy(
        name: "Ashwagandha Golden Milk",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🥛",
        color: "#B03020",
        ingredients: ["Ashwagandha root powder", "Turmeric", "Cinnamon", "Cardamom", "Warm whole milk or oat milk"],
        desc: "Ashwagandha, the revered Ayurvedic adaptogen, is blended with turmeric and warming spices into a nourishing golden milk. This protocol addresses deep fatigue by tonifying the adrenals, calming the nervous system, and rebuilding Ojas — the vital essence of immunity and vitality.",
        steps: [
            "Warm 1.5 cups of milk over medium heat; do not boil.",
            "Whisk in 1 tsp ashwagandha powder, ½ tsp turmeric, ¼ tsp cinnamon, and a pinch of cardamom.",
            "Simmer gently for 5 minutes, stirring continuously to fully dissolve the herbs.",
            "Pour into a mug, sweeten with honey or maple syrup if desired, and drink each morning upon rising."
        ],
        duration: 30
    )

    static let neemTurmericTea = Remedy(
        name: "Neem & Turmeric Detox Tea",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🍃",
        color: "#B03020",
        ingredients: ["Dried neem leaf", "Turmeric root or powder", "Licorice root", "Coriander seeds", "Raw honey"],
        desc: "Neem, called 'the village pharmacy' in India, is one of Ayurveda's most powerful blood purifiers. Combined with anti-inflammatory turmeric and soothing licorice, this tea addresses skin irritations at their root — clearing heat, toxins, and Pitta imbalance from the blood and lymphatic system.",
        steps: [
            "Bring 2 cups of water to a boil and add 1 tsp dried neem leaves and ½ tsp coriander seeds.",
            "Add ½ tsp turmeric and a small piece of licorice root; reduce heat and simmer for 12 minutes.",
            "Strain the tea and let cool until comfortably warm.",
            "Add 1 tsp raw honey and drink once daily in the morning on an empty stomach."
        ],
        duration: 14
    )

    static let boswelliaTurmericPaste = Remedy(
        name: "Boswellia & Turmeric Paste",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🫚",
        color: "#B03020",
        ingredients: ["Boswellia serrata resin or powder", "Turmeric powder", "Black pepper", "Ghee (clarified butter)", "Ginger powder"],
        desc: "Boswellia — known as Shallaki in Sanskrit — has been used in Ayurveda for millennia to reduce joint inflammation and restore mobility. This golden paste combines its active boswellic acids with turmeric's curcumin, amplified by black pepper's piperine for maximum bioavailability.",
        steps: [
            "Combine 1 tsp boswellia powder, 1 tsp turmeric, ½ tsp ginger, and ¼ tsp black pepper in a small bowl.",
            "Warm 1 tbsp ghee in a pan over low heat; add the herb mixture and stir into a smooth paste.",
            "Remove from heat and let cool slightly. Take ½ tsp of the paste with warm water or milk.",
            "Apply a small amount topically to affected joints and massage gently if needed."
        ],
        duration: 21
    )

    static let agniStimulatingBitters = Remedy(
        name: "Agni Stimulating Bitters",
        origin: "Ayurvedic Medicine · India",
        tradition: "Ayurveda",
        tid: "ayurveda",
        icon: "🌱",
        color: "#B03020",
        ingredients: ["Trikatu (ginger, black pepper, long pepper)", "Dried orange peel", "Cumin seeds", "Fennel seeds", "Apple cider vinegar"],
        desc: "In Ayurveda, weak Agni — digestive fire — is considered the root of most disease. These warming bitters kindle Agni, stimulate digestive enzyme production, and restore the body's natural appetite signals. The Trikatu blend is a classical Ayurvedic formula documented in the Charaka Samhita.",
        steps: [
            "Toast 1 tsp cumin and 1 tsp fennel seeds in a dry pan for 2 minutes until fragrant; grind coarsely.",
            "Combine with ½ tsp Trikatu blend and 1 tsp dried orange peel in a small jar.",
            "Add 1 tbsp apple cider vinegar and 2 tbsp warm water; stir well.",
            "Drink 15 minutes before each meal to prime digestion and stimulate appetite."
        ],
        duration: 14
    )

    static let wormwoodCloveTonic = Remedy(
        name: "Wormwood & Clove Tonic",
        origin: "Traditional Chinese Medicine · China",
        tradition: "Traditional Chinese Medicine",
        tid: "tcm",
        icon: "🫖",
        color: "#C03030",
        ingredients: ["Dried wormwood (Artemisia)", "Clove buds", "Huang Lian (Coptis root)", "Fresh ginger slices", "Dried tangerine peel (Chen Pi)"],
        desc: "This TCM digestive tonic combines Qing Hao (wormwood) — documented in the Bencao Gangmu by Li Shizhen — with warming cloves and the bitter detoxifier Huang Lian. Together they clear damp-heat from the middle jiao, reduce bloating, and restore harmonious Qi flow through the stomach meridian.",
        steps: [
            "Bring 3 cups of water to a boil; add 2g dried wormwood, 3 clove buds, and a small piece of Chen Pi.",
            "Add 2-3 slices of fresh ginger and a pinch of Huang Lian; reduce to a simmer.",
            "Decoct on low heat for 20 minutes, allowing the liquid to reduce to approximately 2 cups.",
            "Strain, divide into two portions, and drink one cup warm before lunch and one before dinner."
        ],
        duration: 14
    )

    static let brahmiGinkgoBrew = Remedy(
        name: "Brahmi & Ginkgo Clarity Brew",
        origin: "Traditional Chinese Medicine · China",
        tradition: "Traditional Chinese Medicine",
        tid: "tcm",
        icon: "🧠",
        color: "#C03030",
        ingredients: ["Brahmi (Bacopa monnieri) powder", "Ginkgo biloba leaf", "He Shou Wu (Fo-Ti root)", "Dried wolfberries (Goji)", "Green tea"],
        desc: "A cross-traditional clarity formula drawing from both TCM and Ayurveda. Ginkgo biloba, a sacred TCM herb used for millennia, increases cerebral circulation. Brahmi, the Ayurvedic brain tonic, enhances memory and reduces mental fog. He Shou Wu nourishes the kidney-brain axis described in TCM theory.",
        steps: [
            "Steep 1 tsp ginkgo biloba leaf and 1 tsp dried goji berries in 2 cups just-boiled water for 10 minutes.",
            "Strain and reheat gently; whisk in 1 tsp Brahmi powder until fully dissolved.",
            "Add He Shou Wu tincture (10 drops) or ½ tsp powder if available.",
            "Drink one cup mid-morning and one early afternoon; avoid after 4 PM to support sleep."
        ],
        duration: 21
    )

    static let saffronRhodiolaBlend = Remedy(
        name: "Saffron & Rhodiola Adaptogen Blend",
        origin: "Persian Medicine · Iran",
        tradition: "Persian Medicine",
        tid: "persian",
        icon: "🌸",
        color: "#7B35A0",
        ingredients: ["Persian saffron threads", "Rhodiola rosea root powder", "Rose water", "Cardamom", "Raw honey"],
        desc: "Ibn Sina (Avicenna) wrote extensively on saffron's power to elevate the spirits and strengthen the heart in his Canon of Medicine. This blend pairs royal saffron — the most prized Persian botanical — with adaptogenic Rhodiola to regulate cortisol, restore emotional resilience, and brighten mood through multiple pathways.",
        steps: [
            "Steep a generous pinch of saffron threads (10-15) in 2 tbsp warm water for 10 minutes until golden.",
            "Warm 1.5 cups of water or oat milk and whisk in ½ tsp Rhodiola powder and ¼ tsp cardamom.",
            "Add the saffron water and 1 tsp rose water; stir gently to combine.",
            "Sweeten with 1 tsp raw honey and drink each morning, taking three mindful breaths before the first sip."
        ],
        duration: 21
    )

    static let papayaSeedHoney = Remedy(
        name: "Papaya Seed & Honey Protocol",
        origin: "Southeast Asian Folk Medicine · Thailand",
        tradition: "Southeast Asian Folk Medicine",
        tid: "folk",
        icon: "🍈",
        color: "#C08010",
        ingredients: ["Fresh papaya seeds", "Raw wildflower honey", "Coconut oil", "Lime juice", "Turmeric"],
        desc: "Used across Thailand, Indonesia, and the Philippines, papaya seeds contain carpaine and benzyl isothiocyanate — compounds that have been revered in traditional healing for digestive cleansing. This 7-day intensive protocol is drawn from Jamu tradition and Thai folk medicine for restoring gut harmony.",
        steps: [
            "Scoop seeds from ½ a ripe papaya; rinse well and allow to air dry on a paper towel.",
            "Blend 1 tbsp fresh seeds with 1 tbsp raw honey, 1 tsp lime juice, and a pinch of turmeric until smooth.",
            "Take the blend each morning on an empty stomach, 30 minutes before breakfast.",
            "Follow with 1 glass of warm water with a few drops of coconut oil stirred in."
        ],
        duration: 7
    )

    static let garlicThymeOxymel = Remedy(
        name: "Garlic & Thyme Oxymel",
        origin: "European Herbalism · Greece",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🧄",
        color: "#1A60A0",
        ingredients: ["Fresh garlic cloves", "Fresh or dried thyme", "Raw apple cider vinegar", "Raw honey", "Fennel seeds"],
        desc: "An oxymel — a classical Greek preparation meaning 'acid and honey' — was documented by Hippocrates as a vehicle for delivering bitter and pungent herbs. This European formula uses garlic's allicin and thyme's thymol to address digestive dysbiosis, improve gut motility, and restore the terrain of the intestinal flora.",
        steps: [
            "Crush 4 garlic cloves and let sit for 10 minutes to activate allicin; finely chop or mince.",
            "Combine garlic with 2 tbsp fresh thyme leaves and 1 tsp fennel seeds in a small jar.",
            "Pour ¼ cup raw apple cider vinegar and ¼ cup raw honey over the herbs; seal and shake well.",
            "Take 1 tbsp of the oxymel in 4 oz warm water twice daily — once before breakfast and once before dinner."
        ],
        duration: 21
    )

    static let blackWalnutOregano = Remedy(
        name: "Black Walnut & Oregano Protocol",
        origin: "European Herbalism · Greece",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🌰",
        color: "#1A60A0",
        ingredients: ["Black walnut hull tincture", "Oil of oregano (Origanum vulgare)", "Clove powder", "Wormwood tincture", "Probiotic-rich kefir or yogurt"],
        desc: "Used by European monastic healers and documented in Paracelsus's writings on purification, black walnut hull — rich in juglone — combined with oregano's carvacrol creates a powerful protocol for addressing sugar cravings linked to microbial imbalances. This formula follows the classical European three-herb purge cycle.",
        steps: [
            "Take 20 drops of black walnut hull tincture in 4 oz water each morning before eating.",
            "Add 2-3 drops of oil of oregano to a teaspoon of olive oil and hold under tongue for 30 seconds, then swallow.",
            "Take a pinch of clove powder in warm water with lunch to address afternoon cravings.",
            "End each day with ½ cup plain kefir or yogurt to replenish beneficial flora."
        ],
        duration: 14
    )

    static let valerianPassionflower = Remedy(
        name: "Valerian & Passionflower Evening Tonic",
        origin: "European Herbalism · Europe",
        tradition: "European Herbalism",
        tid: "euro",
        icon: "🌙",
        color: "#1A60A0",
        ingredients: ["Valerian root (dried or tincture)", "Passionflower leaf", "Lemon balm", "Lavender flowers", "Chamomile"],
        desc: "Hildegard von Bingen prescribed valerian for 'those whose mind is troubled at night' in her 12th-century Physica. This evening tonic combines valerian's GABA-potentiating properties with passionflower, lemon balm, and lavender in a classic European sleep formula — calming the nervous system without dependency.",
        steps: [
            "Combine 1 tsp dried valerian root, 1 tsp passionflower, ½ tsp lemon balm, and ½ tsp chamomile flowers.",
            "Pour 2 cups of boiling water over the herbs; cover and steep for 15 minutes.",
            "Strain through a fine mesh; add 4 drops lavender tincture or a drop of food-grade lavender oil.",
            "Drink the full cup warm, 45 minutes before your intended bedtime, in a quiet, dimly lit space."
        ],
        duration: 14
    )

    // MARK: - Symptom → Remedy Mapping

    static let symptomMap: [String: [Remedy]] = [
        "Bloating & Gas": [triphalaGinger, wormwoodCloveTonic],
        "Fatigue": [ashwagandhaGoldenMilk],
        "Digestive Issues": [papayaSeedHoney, garlicThymeOxymel],
        "Skin Irritation": [neemTurmericTea],
        "Brain Fog": [brahmiGinkgoBrew],
        "Sugar Cravings": [blackWalnutOregano],
        "Joint Discomfort": [boswelliaTurmericPaste],
        "Sleep Issues": [valerianPassionflower],
        "Appetite Loss": [agniStimulatingBitters],
        "Mood Changes": [saffronRhodiolaBlend]
    ]

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
