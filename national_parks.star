load("render.star", "render")
load("http.star", "http")
load("time.star", "time")


NPS_API_URL = "https://developer.nps.gov/api/v1/parks"
NPS_API_KEY = "U1KIMycaP5fuImnon9bnGwnEcbG35Dn9hTzvHrtI"

def random():
    return time.now().nanosecond / (1000 * 1000 * 1000)

def main():

    national_parks = {
        'acad': 1919, 'npsa': 1988, 'arch': 1971, 'badl': 1978, 'bibe': 1944, 'bisc': 1980, 'blca': 1999, 'brca': 1924,
        'cany': 1964, 'care': 1971, 'cave': 1930, 'chis': 1980, 'cong': 2003, 'crla': 1902, 'cuva': 2000, 'deva': 1994,
        'dena': 1917, 'drto': 1992, 'ever': 1934, 'gaar': 1980, 'jeff': 2018, 'glac': 1910, 'glba': 1980, 'grca': 1919,
        'grte': 1929, 'grba': 1986, 'grsa': 2004, 'grsm': 1926, 'gumo': 1966, 'hale': 1961, 'havo': 1916, 'hosp': 1921,
        'indu': 2019, 'isro': 1940, 'jotr': 1994, 'katm': 1980, 'kefj': 1980, 'kica': 1940, 'kova': 1980, 'lacl': 1980,
        'lavo': 1916, 'maca': 1941, 'meve': 1906, 'mora': 1899, 'neri': 2020, 'noca': 1968, 'olym': 1938, 'pefo': 1962,
        'pinn': 2013, 'redw': 1968, 'romo': 1915, 'sagu': 1994, 'sequ': 1890, 'shen': 1926, 'thro': 1978, 'viis': 1956,
        'voya': 1971, 'whsa': 2019, 'wica': 1903, 'wrst': 1980, 'yell': 1872, 'yose': 1890, 'zion': 1919
    }

    code_int = int(len(national_parks.keys()) * random())
    park_code = list(national_parks.keys())[code_int]
    rep = http.get("{}?parkCode={}&api_key={}".format(NPS_API_URL, park_code, NPS_API_KEY))

    park = rep.json()["data"][0]
    park_name = park["name"]
    park_designation = park["designation"]
    park_year = national_parks[park_code]
    park_states = park["states"]
    state_string = "State: " if len(park_states.split(",")) == 1 else "States: "
    formatted_states = ", ".join(park_states.split(","))
    random_index = int(len(park["images"]) * random())
    park_image_url = park["images"][random_index]["url"]
    park_image = http.get(park_image_url).body()

    return render.Root(
        child = render.Box(
            color="#8B4720",
            child = render.Column(
                expanded = True,
                main_align = "start",
                children = [
                    render.Marquee(
                        width = 64,
                        child = render.Text(park_name)
                    ),
                    render.Marquee(
                        width = 64,
                        child = render.Row(
                            main_align = "space_between",
                            children = [
                                render.Image(
                                    src = park_image,
                                    height = 24
                                ),
                                render.Column(
                                    children = [
                                        render.Marquee(
                                            width = 64,
                                            child = render.Text(content=park_designation)
                                        ),
                                        render.Marquee(
                                            width = 80,
                                            child = render.Text(content="Established: {}".format(park_year))
                                        ),
                                        render.Row(
                                            children = [
                                                render.Text(content=state_string),
                                                render.Marquee(
                                                    width = 32,
                                                    child = render.Text(content=formatted_states)
                                                )
                                            ]
                                        ),
                                    ]
                                )
                                
                            ]
                        )
                    )
                ],
            )
        )
    )