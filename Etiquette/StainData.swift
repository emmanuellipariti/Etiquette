//
//  StainData.swift
//  Label
//
//  Created by Emmanuel Lipariti on 09/12/24.
//

import Foundation

// Data file containing the remedies
struct Data {
    static let remedies: [String: [(fabric: String, remedy: String)]] = [
        "Blood": [
            ("Cotton and Linen", "Soak in cold water and add salt. For dried stains, use hydrogen peroxide (3%) directly on the stain."),
            ("Silk", "Gently blot with cold water or diluted white vinegar. Avoid using hydrogen peroxide."),
            ("Polyester", "Hydrogen peroxide is safe, but use it carefully to avoid damage."),
            ("Wool", "Avoid hot water, which can set the stain. Use cold water and diluted white vinegar. Blot gently to avoid damaging the fiber.")
        ],
        "Red Wine": [
            ("Cotton and Linen", "Sprinkle salt on the stain or use white wine to dilute the red wine. Wash with cold water immediately after."),
            ("Silk", "Avoid baking soda. Use only white wine or cold water to gently blot."),
            ("Polyester", "Baking soda works well. Apply a paste of baking soda and water, leave it for a while, then rinse."),
            ("Wool", "Avoid using salt, as it may damage the fibers. Use only white wine or cold water. Blot gently to prevent felting.")
        ],
        "Oil and Grease": [
            ("Cotton and Linen", "Sprinkle cornstarch or talc on the stain to absorb the oil. Then, apply dish detergent and wash."),
            ("Silk", "Use talc to absorb the oil, but avoid scrubbing. Do not use dish detergent."),
            ("Polyester", "Dish detergent works well, but always test first in an inconspicuous area to avoid damage."),
            ("Wool", "Avoid chemical detergents. Use talc to absorb the oil, then wash gently with cold water and Marseille soap.")
        ],
        "Grass": [
            ("Cotton and Linen", "Blot with a solution of white vinegar and water (1:1), or use lemon juice. Rinse with cold water."),
            ("Silk", "Avoid lemon and vinegar; use only cold water to gently blot."),
            ("Polyester", "Diluted white vinegar can also be used on polyester without issues."),
            ("Wool", "Use cold water with white vinegar. Avoid rubbing. Gently blot to remove the stain.")
        ],
        "Coffee and Tea": [
            ("Cotton and Linen", "Use a paste of baking soda and water, or apply hydrogen peroxide for stubborn stains."),
            ("Silk", "Avoid baking soda. Use only diluted white vinegar or cold water."),
            ("Polyester", "Hydrogen peroxide is safe for polyester too, but always test in a small hidden area first."),
            ("Wool", "Use cold water and white vinegar. Avoid using baking soda and treat the stain gently.")
        ],
        "Sweat and Deodorant": [
            ("Cotton and Linen", "Apply a paste of baking soda and water, or lemon juice to treat yellow stains."),
            ("Silk", "Avoid baking soda. Use only diluted lemon juice with water."),
            ("Polyester", "Baking soda works well for polyester too. Blot with the baking soda paste."),
            ("Wool", "Use baking soda carefully. It’s better to use diluted lemon juice or white vinegar to treat sweat stains.")
        ],
        "Chocolate": [
            ("Cotton and Linen", "Rub Marseille soap onto the stain and rinse with cold water. For persistent stains, use white vinegar."),
            ("Silk", "Use cold water and a mild soap to remove the stain. Avoid using vinegar."),
            ("Polyester", "White vinegar and Marseille soap work well for polyester."),
            ("Wool", "Avoid vinegar and use cold water with mild soap for wool, like Marseille soap.")
        ],
        "Ink": [
            ("Cotton and Linen", "Soak the garment in milk for several hours, then rinse with water. Alternatively, use denatured alcohol followed by white vinegar."),
            ("Silk", "Avoid denatured alcohol. Use only cold milk to blot the stain."),
            ("Polyester", "Denatured alcohol works well on polyester. Always test it in a hidden area."),
            ("Wool", "Avoid denatured alcohol, as it can damage the fiber. Use cold milk and gently blot the stain, then wash with cold water.")
        ]
    ]
}



